#!ruby -Ku
require "rexml/document"
require 'erb'

##########################################################
#define
ERB_FILE	= './createpage.erb' # YAML�̒�`�t�@�C��
#class
class ItemClass
  attr_accessor :title, :description, :date, :url
  def initialize(title, description, date, url)
	@title = title
	@description = description
	@date = date
	@url = url
  end
end
##########################################################


# erb �̃e���v���[�g���쐬
erb = ERB.new(IO.read(ERB_FILE), nil, "%" )

# XML���[�h�J�n
doc = nil 
File.open("podcast.xml") {|fp| 
  doc = REXML::Document.new(fp)
}
_dispItems = []
if doc != nil then 
	xml = doc.root
	#�^�C�g���̎擾
	_htmltitle = xml.elements['channel/title'].text
	#�S�̂̉��
	_htmldescription = xml.elements['channel/description'].text
	#�C���[�W�̎擾
	_htmlimgurl = xml.elements['channel/itunes:image'].attributes["href"]

	#�A�C�e���̎擾
	xml.elements.each('channel/item') do |item|
		dispItem = ItemClass.new(
			item.elements['title'].text,
			item.elements['description'].text,
			item.elements['pubDate'].text,
			item.elements['enclosure'].attributes["url"]
		)
		_dispItems << dispItem
	end
end

#�o��
htmlfile = File.open("archive.html",'w')
htmlfile.write(erb.result(binding))
htmlfile.close

