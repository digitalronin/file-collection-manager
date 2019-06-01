class FileDupes
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def get_duplicates
    hash = files_by_key
    hash.inject([]) do |list, (_key, files)|
      list << files if files.length > 1
      list
    end
  end

  private

  def files_by_key
    files.inject({}) do |h, file|
      if file['size'] > 0
        key = get_key(file)
        list = h.fetch(key, [])
        list << file
        h[key] = list
      end
      h
    end
  end

  def get_key(file)
    [
      file['sha1'],
      file['size']
    ].join(':')
  end
end
