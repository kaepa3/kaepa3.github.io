#!ruby -Ku
require 'rss/maker'
require 'rss/itunes'
require 'yaml'

YAML_FILE	= "./XMLMaker.yaml" # YAMLの定義ファイル
#yamlのロード
yaml = YAML.load_file(YAML_FILE)

rss = RSS::Maker.make("2.0") do |rss|
  rss.channel.about = 'http://kaepa3.github.io/podcast.xml'
  rss.channel.title = "中野須子のモテないサブカル"
  rss.channel.description = "趣味を見つけるためのPodcast"
  rss.channel.link = "http://kaepa3.github.io/index.html"
  rss.channel.language = "ja"
  rss.channel.itunes_image = "http://kaepa3.github.io/title.jpeg"

  rss.items.do_sort = true
  rss.items.max_size = 30
  yaml.each{|yam|
	  i= rss.items.new_item
	  i.title = yam["title"]
	  i.enclosure.url    = yam["enclosure"]
      i.enclosure.type   = i.enclosure.type   || "audio/mpeg"
      i.enclosure.length = i.enclosure.length || 6336596
	  i.description =  yam["description"]
	  if yam["pubDate"] == "today"
	    i.date =  Time.now
		yam["pubDate"] = i.date
	  else 
		i.date =  yam["pubDate"]
	  end
  }
end

File.open(YAML_FILE, "w") do |io|
  p io.write(YAML.dump(yaml))
end

puts rss

