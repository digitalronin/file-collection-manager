require 'digest/sha1'

class LibFile
  attr_reader :filepath

  BYTES_TO_HASH = 1_000_000

  def initialize(filepath)
    @filepath = filepath
  end

  def exists?
    FileTest.exists? filepath
  end

  def metadata
    bytes = File.read(filepath, BYTES_TO_HASH)

    {
      'path' => filepath,
      'name' => File.basename(filepath),
      'size' => File.size(filepath),
      'sha1' => bytes.nil? ? nil : Digest::SHA1.hexdigest(File.read(filepath, BYTES_TO_HASH))
    }
  end

end
