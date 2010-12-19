require 'rake'
require 'mp3info'

module Id3
  class Rename

    attr_accessor :filenames

    # takes a list of directories or files
    def initialize(dirs_or_files, opts={})
      opt = {:ext => "mp3"}.merge(opts)
      @filenames = dirs_or_files.map do |path|
        if path.directory?
          FileList["#{path}/**/*.#{opt[:ext]}"].sort.to_a
        else
          path
        end
      end.flatten
    end

    


  end
end
