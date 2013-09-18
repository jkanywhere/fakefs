require 'spec_helper'

module FakeFS
  describe File do
    include FakeFS::SpecHelpers

    let(:dir_one) { '/some-dir-one' }
    let(:dir_two) { '/some-dir-two' }

    before do
      FileUtils.mkdir dir_one
      FileUtils.mkdir dir_two
    end

    context '.absolute_path' do
      it 'one argument' do
        expect( File.absolute_path(dir_one) ).to eq dir_one
      end
      it 'two arguments' do
        expect( File.absolute_path( File.join( '..', dir_one ), dir_two ) ).to eq dir_one
      end
      it 'dot dot relative with chdir' do
        Dir.chdir dir_two # Change the Fake current working directory
        expect( Dir.pwd ).to eq dir_two

        # The problem here is that File.expand_path doesn't notice the change
        # in working directory.
        expect( File.absolute_path( File.join( '..', dir_one ) ) ).to eq dir_one
      end
      it 'dot dot relative two argument' do
        expect( File.absolute_path( File.join( '..', dir_one ), dir_two ) ).to eq dir_one
      end
    end

    #
    # The problem in all cases with FakeFS::File.realpath is that by
    # delegating to RealFile.realpath it doesn't know about directories
    # created in the fake file system.
    #
    context '.realpath' do
      it 'one argument' do
        expect( File.realpath(dir_one) ).to eq dir_one
      end
      it 'two arguments' do
        expect( File.realpath( File.join( '..', dir_one ), dir_two ) ).to eq dir_one
      end
      it 'wtf' do
        Dir.chdir dir_two
        expect( Dir.pwd ).to eq dir_two
        expect( File.realpath( File.join( '..', dir_one ) ) ).to eq dir_one
      end
    end
  end
end
