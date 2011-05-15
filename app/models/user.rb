# == Schema Information
# Schema version: 20110515111855
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
#  remember_token     :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :origin, :destination, :password, 
                  :password_confirmation

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

  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
    save_without_validation
  end

  def get_schedule
    require 'nokogiri'
    require 'open-uri'
    require 'cgi'
    #Init params
    origid = self.origin 
    destid = self.destination
    orig_name = CGI::escape(Station.find_by_number(origid).name)
    dest_name = CGI::escape(Station.find_by_number(destid).name)
    date = Date.today.to_s
    time = Time.now.to_s.split[3][0,5]
    found_next = "no"
    table_return = ""

    #Sets the search Url from rail.co.il
    url = "http://rail.co.il/HE/DrivePlan/Pages/DrivePlan.aspx?DrivePlanPage=true&OriginStationId=#{origid}&DestStationId=#{destid}&OriginStationName=#{orig_name}&DestStationName=#{dest_name}&HoursDeparture=all&MinutesDeparture=0&HoursReturn=all&MinutesReturn=0&GoingHourDeparture=true&ArrivalHourDeparture=false&GoingHourReturn=true&ArrivalHourReturn=false&IsReturn=false&GoingTrainCln=#{date}&ReturnningTrainCln=#{date}&IsFullURL=true"
    doc = Nokogiri::HTML(open(url))

    from = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWaySourceStation .td-DescriptionFont").text
    to = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWayDestinationStation .td-DescriptionFont").text
    #init the index
    idx = 0
    #builds a table with all the schedule
    while doc.at_css("##{idx} td:nth-child(2)").nil? == false
      departure = doc.at_css("##{idx} td:nth-child(2)").text
      #handle the case when the hour is not in format 00:00
      if time.length > departure.length
        departure = "0" + departure
      end  
      #if that's the next train available mark it and stop searching
      if (time <=> departure) == -1 and found_next == "no"
        table_return = table_return +  "<tr bgcolor=\"#64E986\">"
        found_next = "yes"
      else
        table_return = table_return +  "<tr>"
      end
      #sets the table columns
      table_return = table_return +  "<td>" + departure + "</td>"
      table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(3)").text + "</td>"
      table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(4)").text + "</td>"
      table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(5)").text + "</td>"
      table_return = table_return +  "</tr>"
      idx = idx + 1
    end
    #returns the table for the html page   
    return table_return

    rescue
      return "<td colspan=\"4\">Cannot load train schedule, try again later</td>"
  end

  private
    def encrypt_password
      unless password.nil?
        self.salt = make_salt
        self.encrypted_password = encrypt(password)
      end
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
