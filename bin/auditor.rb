#!/usr/bin/env ruby

require 'bundler/setup'
require 'digest/sha1'
require 'json'
require 'ruby-progressbar'

class Auditor
  attr_reader :root, :progress_bar

  BYTES_TO_HASH = 1_000_000

  IGNORE_FILE_PATTERNS = [
    %r[^\._]
  ]

  def initialize(root)
    @root = root
  end

  def report
    names = get_filenames
    $stderr.puts

    init_progress_bar(names.length)
    files = names.map {|f| filedata(f)}

    $stderr.puts

    {
      root: root,
      timestamp: Time.now,
      files: files
    }
  end

  private

  def init_progress_bar(count)
    @progress_bar = ProgressBar.create(
      title: 'Hashing',
      total: count,
      output: $stderr,
      format: '|%B| %p%% %e %t',
    )
  end

  def get_filenames
    $stderr.puts
    $stderr.puts "getting filenames..."
    $stderr.puts
    Dir.glob("#{root}/**/*")
      .find_all {|f| FileTest.file?(f)}
      .reject {|f| IGNORE_FILE_PATTERNS.find {|rexp| rexp.match(f)}}
  end

  def filedata(filepath)
    progress_bar.increment
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
