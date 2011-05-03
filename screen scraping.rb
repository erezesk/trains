require 'rubygems'
require 'nokogiri'
require 'open-uri'

#search = "lamborghini diablo roadster"
gets search
# #{CGI.escape(search)}

url = "http://motors.shop.ebay.com/i.html?_nkw=lamborghini+diablo+roadster&_sacat=6001&_dmpt=Motors_Car_Truck_Parts_Accessories&_odkw=lamborghini+diablo+roadster&_osacat=0&bkBtn=&_trksid=m270"
doc = Nokogiri::HTML(open(url))

title = doc.at_css(".ttl").text
price = doc.at_css("#v4-65 .g-b").text
puts "Title: #{title} - Price: #{price}"
puts "Link: " + doc.at_css(".v4lnk")[:href]



