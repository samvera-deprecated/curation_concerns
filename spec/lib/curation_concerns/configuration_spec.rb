require 'spec_helper'

describe CurationConcerns::Configuration do
  describe 'after_create_content=' do
    it 'requires something that responds to #call' do
      expect { subject.after_create_content = 'this string is not callable' }.to raise_error ArgumentError
    end

    it 'allows nil' do
      expect { subject.after_create_content = nil }.to_not raise_error
    end
  end
end
