desc "Update Stations Model, with the stations details from rail.co.il"
task :update_stations => :environment
require 'nokogiri'
require 'open-uri'
require 'cgi'

url = "http://rail.co.il/he/Pages/homepage.aspx"
doc = Nokogiri::HTML(open(url))

idx = 2 #2 is the first station
#while element exists in droplist
while doc.at_css("#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option[#{idx}]").nil? == false
  begin
    #getting station number and name
    station_id = doc.at_css("#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option[#{idx}]").to_s.split("\"")[1]
    station_name = doc.at_css("#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option[#{idx}]").text

    #getting the station by id
    station = Station.find(station_id)

    #checking if the station name is not correct
    if station.name != station_name
      station.update_attribute(:name, station_name)
    end
  
    #if the station doesn't exists, we create it
    rescue ActiveRecord::RecordNotFound
      Station.create(:station_id => station_id, :name => station_name)
    ensure
      idx = idx + 1
  end
end
