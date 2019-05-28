#!/usr/bin/env ruby

require 'json'
require 'digest/sha1'

# Output sets of files whose pathnames conflict, when downcased

def main(json)
  files = JSON.parse(json).fetch('files')
  dupes = get_name_conflicts(files)
  dupes.each do |list|
    # resolve_conflict(list)
    list.each {|file| puts file['path']}
    puts
  end
end

def get_name_conflicts(files)
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
  str = file['path'].downcase
  Digest::SHA1.hexdigest(str)
end

# For any set of conflicting filenames, remove the file whose name
# is alphabetically first.
# NB: This only works if there are only 2 files with the 'same'
# name, which is the situation I had.
def resolve_conflict(files)
  filename = files
    .map {|f| f['path']}
    .sort
    .first
  puts %[rm "#{filename}"]
end

json = $stdin.read
main json


