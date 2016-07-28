require 'open-uri'
require 'nokogiri'

# ctrl + s on http://kitt.lewagon.org/camps/30/classmates

url = "Kitt - Le Wagon.htm"
html_doc = Nokogiri::HTML(open(url))

file = File.open('classmates_li.txt', 'w')

# need to make the parsing of <img> in two time too avoid undefined method `[]' for nil:NilClass
def get_picture(el)
  picture = el.search('.img-thumbnail').to_s
  picture = picture.scan(/ers\/\d+.\w{3}/)[0][4..-1] unless picture == ""
  picture
end

name_link_array = []
img_array = []

# name, username, and pic are not in the same loop. That is why I needed to make two array
# and join them after
html_doc.search('.valign-middle').each do |el|
  name = el.search('strong').text.strip unless el.search('strong').text == ""
  username = el.search('a').first.text.strip unless el.search('a').first.text.strip == ""
  pic = get_picture(el)
  if name && username
    name_link_array << " alt=\"#{name}\">\n<div class=\"user_link\">\n<a href=\"https://#{username}.github.io/profile\">#{name}</a>\n</div>\n</div>\n"
  end
  img_array << "<div class=\"card\">\n<img src=\"images/#{pic}\"" unless pic.empty?
end

#
name_link_array.each_with_index do |el, index|
  li = img_array[index] + el
  file.write(li)
end
