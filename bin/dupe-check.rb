#!/usr/bin/env ruby

require 'json'
require 'pp'
require './lib/file_dupes'

def main(json)
  files = JSON.parse(json).fetch('files')
  dupes = FileDupes.new(files).get_duplicates()
  dupes.each do |list|
    list.each do |file|
      pp(file)
      puts
    end
  end
end

json = $stdin.read
main json
