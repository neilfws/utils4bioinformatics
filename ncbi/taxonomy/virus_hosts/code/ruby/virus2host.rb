#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

def get_host(uid)
	url   = "http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&lvl=3&lin=f&keep=1&srchmode=1&unlock&id=" + uid.to_s
	doc   = Nokogiri::HTML.parse(open(url).read)
	data  = doc.xpath("//td").collect { |x| x.inner_html.split("<br>") }.flatten
	orgn = ""
	rank = ""
	host = ""
	data.each do |e|
		orgn = $1 if e =~ /<h2>(.*?)<\/h2>/
		rank = $1 if e =~ /Rank:\s+<\/em>(.*?)$/
		host = $1 if e =~ /Host:\s+<\/em>(.*?)$/
	end
	puts [uid, rank, orgn, host].join("\t")
end

get_host(ARGV[0])