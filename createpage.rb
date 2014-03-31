#!ruby -Ku
require "rexml/document"
require 'erb'

##########################################################
#define
ERB_FILE	= './createpage.erb' # YAMLの定義ファイル
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


# erb のテンプレートを作成
erb = ERB.new(IO.read(ERB_FILE), nil, "%" )

# XMLリード開始
doc = nil 
File.open("podcast.xml") {|fp| 
  doc = REXML::Document.new(fp)
}
_dispItems = []
if doc != nil then 
	xml = doc.root
	#タイトルの取得
	_htmltitle = xml.elements['channel/title'].text
	#全体の解説
	_htmldescription = xml.elements['channel/description'].text
	#イメージの取得
	_htmlimgurl = xml.elements['channel/itunes:image'].attributes["href"]

	#アイテムの取得
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

#出力
htmlfile = File.open("archive.html",'w')
htmlfile.write(erb.result(binding))
htmlfile.close

