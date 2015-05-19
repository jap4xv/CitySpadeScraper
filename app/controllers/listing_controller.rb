require 'open-uri'

class ListingController < ApplicationController

  #def index
	
  #end
  
  def index
    locations = {}
	
	doc = Nokogiri::HTML(open("http://www.related.com/feeds/ZillowAvailabilities.xml"))
    doc.css('listing location').each do |location|
		address = location.css('streetaddress').text
		
		if not locations.key?(address)
		
			city = location.css('city').text
			state = location.css('state').text
			zip = location.css('zip').text
			
			query = address + ', ' + city + ', ' + state + ' ' + zip
			apiKey = 'AIzaSyDi-6WsDLYNZtAR6YPnVGXEkTywjDZ8YVw'
			apiEndpoint = "https://maps.googleapis.com/maps/api/place/textsearch/json?query="
			url = apiEndpoint + query + "&key=" + apiKey 
			encoded_url = URI.encode(url)
			
			response = HTTParty.get(URI.parse(encoded_url) )
			body = JSON.parse(response.body)
			
			puts response
			
			lat = 'not found'
			long = 'not found'
			
			puts body['results']
			if body['results'].any? 
				lat = body['results'][0]['geometry']['location']['lat']
				long = body['results'][0]['geometry']['location']['lng']
			end
			
			
			locations[address] = [lat, long]
			
			puts query
			
		end
		
	end
	
	locationsHTML = ""
	
	locations.each do |location, coords|
		locationsHTML += "<h2>" + location + "</h2>"
		locationsHTML += "<h3>Latitude:" + coords[0].to_s + "</h3>"
		locationsHTML += "<h3>Longitude:" + coords[1].to_s + "</h3><br>"
		
	end
	
	render html: locationsHTML.html_safe
	
  end
  
  #helper_method :scrapeXML

end
