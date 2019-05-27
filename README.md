# File Collection Manager

Ruby scripts to help manage a collection of large binary files by maintaining a
catalogue and reporting duplicates. E.g. a collection of MP3 files, built up
over time, might have several copies the same audio track under slightly
different names, or in different locations in a directory tree.

## bin/auditor.rb

Takes a root directory and finds all the files within it, outputting a JSON
document for each file, including:

 * File name
 * File path
 * File size in bytes
 * SHA1 hash of the first 1,000,000 bytes in the file

Note: This script can take some time to run, depending on the number
of directories to traverse, and files to fingerprint.

### Example usage

    ./bin/auditor.rb ~/Music > music.json

## bin/dupe-check.rb

Takes the JSON output from `auditor.rb` and looks for files with matching sizes
and SHA1 hashes. For each such file, output the file paths on consecutive
lines, with a blank line between each such grouping.

### Example usage

    cat music.json | ./bin/dupe-check.rb
