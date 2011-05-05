require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi'

url = "http://rail.co.il/he/Pages/homepage.aspx"
doc = Nokogiri::HTML(open(url))

idx = 2 #2 is first station
while doc.at_css("#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option[#{idx}]").nil? == false
  puts doc.at_css("#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option[#{idx}]").to_s.split("\"")[1]
  puts doc.at_css("#ctl00_PlaceHolderMain_ucSmallDrivePlan_cmbOriginStation option[#{idx}]").text
  idx = idx + 1
end

#title = doc.at_css(".ttl").text
#price = doc.at_css("#v4-65 .g-b").text
#puts "Title: #{title} - Price: #{price}"
#puts "Link: " + doc.at_css(".v4lnk")[:href]



