require 'mp3info'

module Id3
  class Rename

    # will *always* remove an id3 tag if present on write
    # only updates the value of it is not nil
    class Tag
      VALID = [:title, :album, :artist, :year, :comment, :tracknum, :conductor, :composer]
      VALID_HASH_KEYS = { :title => 'TIT2',  :album => 'TALB', :artist => 'TPE1', :year => 'TYER', :comment => 'COMM', :tracknum => 'TRCK', :conductor => 'TPE3', :composer => 'TCOM' }
      VALID.each {|v| attr_accessor v }

      alias_method :num, :tracknum
      alias_method :num=, :tracknum=

      attr_accessor :path

      # if a file is given, reads the values from the file
      # the hash will then override any of those values (if any)
      def initialize(hash={})
        hash.each {|k,v| instance_variable_set("@#{k}".to_sym, v) }
      end

      # sets the file attribute and returns self for chaining
      def read_file(fn, version=2)
        @path = fn
        Mp3Info.open(fn) do |mp3|
          tag_to_use = case version
                       when 2 ; :tag2
                       when 1 ; :tag1
                       end
          tag = mp3.send(tag_to_use)
          VALID.each do |key|
            value = 
              if tag.respond_to?(key)
                tag.send(key)
              else
                tag[VALID_HASH_KEYS[key]]
              end
            self.send("#{key}=".to_sym, value)
          end
        end
        self
      end

      # writes current attributes to the file
      # returns self
      def update!(fn=path, remove_tag1=true)
        Mp3Info.open(fn) do |mp3|
          tag = mp3.tag2
          VALID.each do |key|
            if self.send(key)
              if tag.respond_to?("#{key}=")
                tag.send("#{key}=", self.send(key))
              else
                tag[VALID_HASH_KEYS[key]] = self.send(key)
              end
            end
          end
          mp3.removetag1 if mp3.hastag1?
        end
        self
      end
    end
  end
end
