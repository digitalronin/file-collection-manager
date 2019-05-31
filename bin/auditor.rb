#!/usr/bin/env ruby

require 'digest/sha1'
require 'json'

BYTES_TO_HASH = 1_000_000

IGNORE_FILE_PATTERNS = [
]

def main(root)
  files = get_file_data(root)
  $stderr.puts
  {
    root: root,
    timestamp: Time.now,
    files: files
  }
end

def get_file_data(root)
  get_filenames(root).map {|f| filedata(f)}
end

def filedata(filepath)
  $stderr.print '.'
  bytes = File.read(filepath, BYTES_TO_HASH)
  {
    path: filepath,
    name: File.basename(filepath),
    size: File.size(filepath),
    sha1: bytes.nil? ? nil : Digest::SHA1.hexdigest(File.read(filepath, BYTES_TO_HASH))
  }
end

def get_filenames(root)
  $stderr.puts "getting filenames..."
  Dir.glob("#{root}/**/*")
    .find_all {|f| FileTest.file?(f)}
    .reject {|f| IGNORE_FILE_PATTERNS.find {|rexp| rexp.match(f)}}
end

dir = ARGV.shift
puts main(dir).to_json
