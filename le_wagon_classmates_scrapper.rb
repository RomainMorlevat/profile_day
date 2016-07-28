require 'open-uri'
require 'nokogiri'

# ctrl + s on http://kitt.lewagon.org/camps/30/classmates

url = "Kitt - Le Wagon.htm"
html_doc = Nokogiri::HTML(open(url))

file = File.open('classmates_li.txt', 'w')

def get_picture(el)
  picture = el.search('.img-thumbnail').to_s
  picture = picture.scan(/ers\/\d+.\w{3}/)[0][4..-1] unless picture == ""
  picture
end

name_link_array = []
img_array = []

html_doc.search('.valign-middle').each do |el|
  name = el.search('strong').text.strip unless el.search('strong').text == ""
  username = el.search('a').first.text.strip unless el.search('a').first.text.strip == ""
  pic = get_picture(el)
  if name && username
    name_link_array << " alt=\"#{name}\"><a href=\"https://#{username}.github.io/profile\">#{name}</a></li>\n"
  end
  img_array << "<li><img src=\"images/#{pic}\"" unless pic.empty?
end

p name_link_array
p img_array

name_link_array.each_with_index do |el, index|
  li = img_array[index] + el
  file.write(li)
end
