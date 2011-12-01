# Author 		: 	James Lafa 
# Git 			: 	https://github.com/jameslafa
# Description 	: 	This is my first Ruby script, so please be nice with me ;-)
# 					500px.com is a really great website with awesome pictures. When I add one to my favorites
# 					I like to download it to save a copy on my computer and watch it when ever I want.
# 					This is was this script does : download your favorties pictures !
# License		: 	Under the MIT open source license. Do what ever you want !

# Load required libraries
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

# Configuration. You should change this !
login = "jmslf"
download_folder = "downloads/" # it need to end with /

# Define rss url
source = "http://500px.com/" + login + "/favorites.rss"

# Initialize the content
content = ""

# Open the source and read it
open(source) do |s| content = s.read end

# Parse the rss feed and create the rss object
rss = RSS::Parser.parse(content, false)

puts "Root values"
print "RSS title: ", rss.channel.title, "\n"
rss.items.each do |item| 
	link = item.link
	# Get the item description : where we can find the image url
	description = item.description 
	# Find the small image url. It ends with 3.jpg
	small_image_links_array = description.scan(/http:[\S]*3.jpg/)

	# Nude images are hidden and not present in the rss feed so nothing will match. 
	# For the moment the script will only work with non nude images
	
	# Test if the link was found 
	if small_image_links_array.size > 0
		# There is only one small image link in the description, so we can work with the index 0
		small_image_link = small_image_links_array[0];
		# The big image url is the same but with 4.jpg instead of 3.jpg
		long_image_link = small_image_link.sub(/3.jpg/, "4.jpg")
		
		# Get image 500px id. It's the last digit series of the item link
		image_id = link.match(/[[:digit:]]*$/)
		# Now it's time to download the image
		download_file_name = download_folder + image_id.to_s + ".jpg"
		# Don't download files twice, so check before if the picture already exist
		if !FileTest.exist?( download_file_name )
			# Create a new file
			open(download_file_name, 'wb') do |file|
				puts "Downloading " + download_file_name
				# Save the image content in the file
	  			file << open(long_image_link).read
			end
		end
	end
end