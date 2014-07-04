#!/usr/bin/ruby

# save CiteULike JSON in mongodb database
def json2mongo(db = "citeulike", col = "articles", user = "neils")
    require "mongo"
    require "json/pure"
    require "open-uri"

    puts "Fetching JSON..."
    db  = Mongo::Connection.new.db(db)
    col = db.collection(col)
    url = "http://www.citeulike.org/json/user/" + user
    j   = JSON.parse(open(url).read)
    j.each do |article|
        article[:_id] = article['article_id']
        col.save(article)
    end
    puts "Done. Collection contains: #{col.count} articles."
end

# run with default options
json2mongo
