#!/usr/bin/env ruby

require 'bundler/setup'
require 'json'
require 'ruby-progressbar'
require './lib/lib_file'

class Auditor
  attr_reader :root, :progress_bar

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
    LibFile.new(filepath).metadata()
  end

end

dir = ARGV.shift

if dir.nil?
  puts <<~USAGE

  Invoke this script, supplying a directory as the only argument.

  The output (to STDOUT) will be a JSON manifest of all files
  stored in or below the supplied root directory.

  USAGE
  exit
end

puts Auditor.new(dir).report.to_json
