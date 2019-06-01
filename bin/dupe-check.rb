#!/usr/bin/env ruby

require 'json'
require './lib/file_dupes'

def main(json)
  files = JSON.parse(json).fetch('files')
  dupes = FileDupes.new(files).get_duplicates()
  dupes.each do |list|
    list.each {|file| puts file['path']}
    puts
  end
end

json = $stdin.read
main json


