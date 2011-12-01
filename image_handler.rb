def get_image_link_from_html_page(link)
	# Open the HTML page with Nokogiri
	html_page = Nokogiri::HTML(open(link))

	# The image url we want is in a link. To find it, use css method
	big_image_array = html_page.css("#photo a")

	# There should be only one link
	if big_image_array.size == 1
		# Get the href attribute of the link
		big_image_link = big_image_array[0]["href"]
		# Return the link
		return big_image_link
	else
		return ""
	end
end

def download_image_file(source_link, destination_file)
	# Create a new file
	open(destination_file, 'wb') do |file|
		puts "=> Downloading " + source_link
		puts "   into " + destination_file
		# Save the image content in the file
		file << open(source_link).read
	end
end