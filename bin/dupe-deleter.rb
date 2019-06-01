#!/usr/bin/env ruby

require 'json'
require './lib/file_dupes'

def main(json)
  files = JSON.parse(json).fetch('files')
  dupes = FileDupes.new(files).get_duplicates()
  dupes.each do |list|
    erase_all_but_first(list)
  end
end

def erase_all_but_first(files)
  files.shift
  files.each {|f| File.delete(f['path'])}
end

json = $stdin.read
main json


