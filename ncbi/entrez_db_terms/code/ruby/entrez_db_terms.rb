#!/usr/bin/ruby
require 'bio'
require 'nokogiri'
require 'open-uri'

Bio::NCBI.default_email = "me@me.com"
outd = File.expand_path("../../../data", __FILE__)
ncbi = Bio::NCBI::REST.new
url  = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?db="
ncbi.einfo.each do |db|
  puts "Processing #{db}..."
  outf = outd + "/" + "#{db}.txt"
  File.open(outf, "w") do |f|
    doc = Nokogiri::XML(open("#{url + db}"))
    doc.xpath("//FieldList/Field").each do |field|
      name = field.xpath("Name").inner_html
      fullname = field.xpath("FullName").inner_html
      description = field.xpath("Description").inner_html
      f.write("#{name},#{fullname},#{description}\n")
    end
  end
  puts "Wrote file #{outf}"
end
