# == Schema Information
# Schema version: 20110504120635
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  origin             :string(255)
#  destination        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :origin, :destination, :password, :password_confirmation

  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_presence_of   :name, :email, :origin, :destination
  validates_length_of     :name, :maximum => 50
  validates_format_of     :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false  

  validates_confirmation_of :password

  validates_presence_of :password
  validates_length_of   :password, :within => 6..40

  before_save :encrypt_password

  def has_password?(submitted_password)
     encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def get_schedule
    require 'nokogiri'
    require 'open-uri'
    require 'cgi'
    #Init params
    origid = self.origin 
    destid = self.destination
    date = Date.today.to_s
    time = Time.now.to_s.split[3][0,5]
    found_next = "no"
    table_return = ""
    #Sets the search Url from rail.co.il
    url = "http://rail.co.il/HE/DrivePlan/Pages/DrivePlan.aspx?DrivePlanPage=true&OriginStationId=#{origid}&DestStationId=#{destid}&OriginStationName=&DestStationName=&HoursDeparture=all&MinutesDeparture=0&HoursReturn=14&MinutesReturn=0&GoingHourDeparture=true&ArrivalHourDeparture=false&GoingHourReturn=true&ArrivalHourReturn=false&IsReturn=false&GoingTrainCln=#{date}&ReturnningTrainCln=#{date}&IsFullURL=true"
    doc = Nokogiri::HTML(open(url))

    from = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWaySourceStation .td-DescriptionFont").text
    to = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWayDestinationStation .td-DescriptionFont").text
    #init the index
    idx = 0
    #builds a table with all the schedule
    table_return = "<table border=\"1\"><tr align=\"center\"><th colspan=\"2\">From: #{from}</th><th colspan=\"2\">To: #{to}</th></tr>"
    table_return = table_return + "<tr align=\"center\"><th>Departure</th><th>Arrival</th><th>Travel length</th><th>Is Direct?</th></tr>"
    while doc.at_css("##{idx} td:nth-child(2)").nil? == false
      departure = doc.at_css("##{idx} td:nth-child(2)").text
      #handle the case when the hour is not in format 00:00
      if time.length > departure.length
        departure = "0" + departure
      end  
      #if that's the next train available mark it and stop searching
      if (time <=> departure) == -1 and found_next == "no"
        table_return = table_return +  "<tr align=\"center\" bgcolor=\"lightgreen\">"
        found_next = "yes"
      else
        table_return = table_return +  "<tr align=\"center\">"
      end
      #sets the table columns
      table_return = table_return +  "<td>" + departure + "</td>"
      table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(3)").text + "</td>"
      table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(4)").text + "</td>"
      table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(5)").text + "</td>"
      table_return = table_return +  "</tr>"
      idx = idx + 1
    end
    table_return = table_return + "</table>"
    #returns the table for the html page
    return table_return
  end

  private
    def encrypt_password
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
