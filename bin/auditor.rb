#!/usr/bin/env ruby

require 'digest/sha1'
require 'json'

class Auditor
  attr_reader :root

  BYTES_TO_HASH = 1_000_000

  IGNORE_FILE_PATTERNS = [
    %r[^\._]
  ]

  def initialize(root)
    @root = root
  end

  def report
    files = get_filenames.map {|f| filedata(f)}
    $stderr.puts
    {
      root: root,
      timestamp: Time.now,
      files: files
    }
  end

  private

  def get_filenames
    $stderr.puts "getting filenames..."
    Dir.glob("#{root}/**/*")
      .find_all {|f| FileTest.file?(f)}
      .reject {|f| IGNORE_FILE_PATTERNS.find {|rexp| rexp.match(f)}}
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

end

dir = ARGV.shift
puts Auditor.new(dir).report.to_json
