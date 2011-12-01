# This is my first Ruby script, so please be nice with me ;-)
# 500px.com is a really great website with awesome pictures. When I add one to my favorites
# I like to download it to save a copy on my computer and watch it when ever I want.
# This is was this script does : download your favorties pictures !
# 
# Author:: James Lafa
# Copyright:: Copyright (c) 2011
# License:: MIT open source license http://www.opensource.org/licenses/mit-license.php

# Load required libraries
require 'rubygems'
require 'nokogiri'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

# Include the image handler files
require_relative 'image_handler.rb'


# Configuration. You should change this !
LOGIN_NAME = "jmslf"
DOWNLOAD_FOLDER = "downloads/" # it need to end with /


# Create the download directory folder if it does not exist
Dir.mkdir(DOWNLOAD_FOLDER) unless File.directory?(DOWNLOAD_FOLDER)

# Define rss url
source = "http://500px.com/" + LOGIN_NAME + "/favorites.rss"

# Initialize the content
content = ""

# Open the source and read it
puts "Downloading rss feed from : " + source
open(source) do |s| content = s.read end

# Parse the rss feed and create the rss object
rss = RSS::Parser.parse(content, false)

rss.items.each do |item| 
	# Get image page link
	link = item.link

	# Extract the image unique id from page link
	image_id = link.match(/[[:digit:]]*$/)

	# Build the downloaded image file path
	download_file_name = DOWNLOAD_FOLDER + image_id.to_s + ".jpg"

	# Test if this file already exist before trying to download it
	if !FileTest.exist?(download_file_name)
		# Get the item description : where we can find the image url
		description = item.description

		# Initialize the image url to download
		image_url_to_download = ""

		# Try to find the small image link. 2 possible results :
		# 1 - this is a non nude picture : there is an image called 3.jpg, this is the small image url. To get the big image url, get the 4.jpg
		# 2 - this is a nude picture : there isn't any image called 3.jpg. In this case, we have to fetch the image page url and find the image link inside

		small_image_links_array = description.scan(/http:[\S]*3.jpg/)

		if small_image_links_array.size == 1
			# This is a non nude picture, great it's easy !
			small_image_link = small_image_links_array[0];
			# To get the big image url, change 3.jpg by 4.jpg
			image_url_to_download = small_image_link.sub(/3.jpg/, "4.jpg")

		else
			# This is a nude picture, no problem, we just have to explore the DOM of the image page
			image_url_to_download = get_image_link_from_html_page(link)

		end

		# Now it's time to download the image 
		if image_url_to_download.size > 0 && image_url_to_download.start_with?("http://")
			download_image_file(image_url_to_download, download_file_name)
		end

	else
		puts download_file_name + " => already exist, no need to redownload it"
				
	end
end

