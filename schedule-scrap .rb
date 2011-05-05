require 'nokogiri'
require 'open-uri'
require 'cgi'

def get_schedule(origid, destid)

  date = Date.today.to_s
  time = Time.now.to_s.split[3][0,5]
  found_next = "no"
  table_return = ""

  url = "http://rail.co.il/HE/DrivePlan/Pages/DrivePlan.aspx?DrivePlanPage=true&OriginStationId=#{origid}&DestStationId=#{destid}&OriginStationName=&DestStationName=&HoursDeparture=all&MinutesDeparture=0&HoursReturn=14&MinutesReturn=0&GoingHourDeparture=true&ArrivalHourDeparture=false&GoingHourReturn=true&ArrivalHourReturn=false&IsReturn=false&GoingTrainCln=#{date}&ReturnningTrainCln=#{date}&IsFullURL=true"
  doc = Nokogiri::HTML(open(url))

  from = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWaySourceStation .td-DescriptionFont").text
  to = doc.at_css("#ctl00_PlaceHolderMain_ucTicketWizard_OneWayDestinationStation .td-DescriptionFont").text

  idx = 0

  table_return = "<table border=\"1\"><tr align=\"center\"><th colspan=\"2\">From: #{from}</th><th colspan=\"2\">To: #{to}</th></tr>"
  table_return = table_return + "<tr align=\"center\"><th>Departure</th><th>Arrival</th><th>Travel length</th><th>Is Direct?</th></tr>"
  while doc.at_css("##{idx} td:nth-child(2)").nil? == false
    departure = doc.at_css("##{idx} td:nth-child(2)").text
  
    if time.length > departure.length
      departure = "0" + departure
    end  

    if (time <=> departure) == -1 and found_next == "no"
      table_return = table_return +  "<tr align=\"center\" bgcolor=\"lightgreen\">"
      found_next = "yes"
    else
      table_return = table_return +  "<tr align=\"center\">"
    end
    table_return = table_return +  "<td>" + departure + "</td>"
    table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(3)").text + "</td>"
    table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(4)").text + "</td>"
    table_return = table_return +  "<td>" + doc.at_css("##{idx} td:nth-child(5)").text + "</td>"
    table_return = table_return +  "</tr>"
    idx = idx + 1
  end
  table_return = table_return + "</table>"
  
  return table_return
end

