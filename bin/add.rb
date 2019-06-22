#!/usr/bin/env ruby

require 'json'
require './lib/lib_file'

# Add a file to a json manifest

def get_key(file)
  [
    file['sha1'],
    file['size']
  ].join(':')
end

def add_file_if_new(files, filepath)
  keys = files.map {|f| get_key(f)}

  file = LibFile.new(filepath).metadata
  key = get_key(file)

  unless keys.include?(key)
    files << file
  end

  files
end

############################################################


manifest = ARGV.shift
filepath = ARGV.shift

if manifest.nil? || filepath.nil?
  puts <<~USAGE

  Invoke this script with 2 arguments:

      * Filename of a JSON manifest file
      * Path to a file

  The script will add the file to the manifest, unless the manifest already
  includes it.

  If the JSON manifest file does not exist, this script will create it.

  USAGE
  exit
end

hash = if FileTest.exists?(manifest)
         JSON.parse(File.read manifest)
       else
         { 'timestamp' => Time.now, 'files' => [] }
       end

files = hash['files']
hash['files'] = add_file_if_new(files, filepath)

File.open(manifest, 'w') { |f| f.puts hash.to_json }
