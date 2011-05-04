require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'cgi'

origid = 3700
destid = 9100
date = Date.today.to_s

url = "http://www.rail.co.il/HE/DrivePlan/Pages/DrivePlan.aspx?DrivePlanPage=true&OriginStationId=#{origid}&DestStationId=#{destid}&OriginStationName=&DestStationName=&HoursDeparture=all&MinutesDeparture=0&HoursReturn=all&MinutesReturn=0&GoingHourDeparture=true&ArrivalHourDeparture=false&GoingHourReturn=true&ArrivalHourReturn=false&IsReturn=false&GoingTrainCln=#{date}&ReturnningTrainCln=#{date}&IsFullURL=true"
doc = Nokogiri::HTML(open(url))

#from = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWaySourceStation .td-DescriptionFont").text
#to = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWayDestinationStation .td-DescriptionFont").text
#puts "From: #{from} - To: #{to}"
#puts "Link: " + url
#puts "Link: " + doc.at_css(".v4lnk")[:href]

#idx = 0
#while doc.at_css("##{idx} td:nth-child(2)").nil? == false
#  puts "Row: " + idx.to_s
#  puts "Departure: "      + doc.at_css("##{idx} td:nth-child(2)").text
#  puts "Arrival: "        + doc.at_css("##{idx} td:nth-child(3)").text
#  puts "Travel length: "   + doc.at_css("##{idx} td:nth-child(4)").text
#  puts "Is Direct?: "     + doc.at_css("##{idx} td:nth-child(5)").text
#  puts "---------------------------"
#  idx = idx + 1
#end


idx = 0

puts "<table border=\"1\"><tr align=\"center\"><th colspan=\"2\">From: #{from}</th><th colspan=\"2\">To: #{to}</th></tr>"
puts "<tr align=\"center\"><th>Departure</th><th>Arrival</th><th>Travel length</th><th>Is Direct?</th></tr>"
while doc.at_css("##{idx} td:nth-child(2)").nil? == false
  puts "<tr align=\"center\">"
  puts "<td>" + doc.at_css("##{idx} td:nth-child(2)").text + "</td>"
  puts "<td>" + doc.at_css("##{idx} td:nth-child(3)").text + "</td>"
  puts "<td>" + doc.at_css("##{idx} td:nth-child(4)").text + "</td>"
  puts "<td>" + doc.at_css("##{idx} td:nth-child(5)").text + "</td>"
  puts "</tr>"
  idx = idx + 1
end
puts "</table>"
