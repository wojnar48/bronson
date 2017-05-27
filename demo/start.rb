#!/usr/bin/env ruby

puts 'Welcome to Bronson demo!'
puts 'this simple script will create dample db and run server'
puts 'please navigate to localhost:3000 to view demo'
puts 'hit ctrl + c to stop server'
%x(cat demo/ascii.sql | sqlite3 ascii.db)
%x(ruby demo/server.rb)
