
module Id3
  class Rename
    # a class that stores multiple tag versions for easy edit manipulations

    class EditTag
      CLASSICAL_ORDER = %w(track title album conductor composer).map(&:to_sym)
      # tag only has the track number set which is derived from the input
      # order
      attr_accessor :from_input_order
      # tag derived from splitting up the filename
      attr_accessor :from_filename
      # the tag the file actually starts with
      attr_accessor :original
      # the final tag
      attr_accessor :final

      def initialize(file, input_order_num=nil)
        @from_input_order, @from_filename, @original
        set_from_filename(file) 
      end

      # order consists of any valid tags (as symbols)
      # combine takes an array of ranges or arrays
      def set_from_filename(filename, opts={})
        opt = {:split=>'-', :order => [:track, :title, :album, :artist], :combine=>nil }.merge(opts)
        core = File.basename(filename, filename.chomp(File.extname(filename)))
        pieces = core.split(opt[:split])
        if opt[:combine]
          opt[:combine]
        end
      end

      # writes the tag to the file
      def update!(using=:final)
        @final.update!
      end

    end

  end
end
