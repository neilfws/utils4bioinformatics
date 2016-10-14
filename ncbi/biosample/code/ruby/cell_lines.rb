#!/usr/bin/ruby

# cell_lines.rb
# search NCBI biosample database for misidentified cell lines
# then search pubmed for those cell lines & return count

require 'bio'

Bio::NCBI.default_email = "me@me.com"
ncbi   = Bio::NCBI::REST.new

search = ncbi.esearch("cell line status misidentified[Attribute]", {"db" => "biosample", "retmax" => 500})

search.each do |id|
	record = ncbi.efetch(id, {"report" => "full", "db" => "biosample", "mode" => "text"})
	line = record.split("\n").find {|e| /\/cell line="(.*?)"/ =~ e }
	if line =~ /cell line="(.*?)"/
		pubmed = ncbi.esearch_count("#{$1}[TIAB]", {"db" => "pubmed"})
		puts "#{$1}\t#{pubmed}"
	end
end
