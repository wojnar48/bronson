#!/usr/bin/env ruby

puts 'Welcome to Bronson demo!'
puts 'this simple script will create dample db and run server'
%x(cat ascii.sql | sqlite3 ascii.db)
%x(ruby demo/server.rb)
