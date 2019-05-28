#!/usr/bin/env ruby

require 'json'

def main(json)
  files = JSON.parse(json).fetch('files')
  dupes = get_duplicates(files)
  dupes.each do |list|
    list.each {|file| puts file['path']}
    puts
  end
end

def get_duplicates(files)
  hash = files_by_key(files)
  hash.inject([]) do |list, (_key, files)|
    list << files if files.length > 1
    list
  end
end

def files_by_key(files)
  files.inject({}) do |h, file|
    key = get_key(file)
    list = h.fetch(key, [])
    list << file
    h[key] = list
    h
  end
end

def get_key(file)
  [
    file['sha1'],
    file['size']
  ].join(':')
end

json = $stdin.read
main json


