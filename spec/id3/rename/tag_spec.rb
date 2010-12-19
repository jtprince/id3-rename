require 'spec_helper'

require 'id3/rename/tag'

describe 'reading id3 tags' do

  it 'reads v2 tags' do
    @file = TESTFILES + "/1000Hz-5sec.banshee.mp3"
    tag = Id3::Rename::Tag.new.read_file(@file)
    p tag
  end

  it 'reads v1 tags' do
    1.is 1
  end

end
