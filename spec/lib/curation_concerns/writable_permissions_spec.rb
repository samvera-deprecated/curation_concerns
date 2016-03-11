require 'spec_helper'

describe CurationConcerns::Permissions::Writable do
  class SampleModel < ActiveFedora::Base
    include CurationConcerns::Permissions::Writable
  end

  before do
    # We won't have to remove the orphan permissions when this is fixed:
    # https://github.com/projecthydra/hydra-head/issues/290
    Hydra::AccessControls::Permission.destroy_all
  end

  let(:subject) { SampleModel.new }

  describe '#permissions' do
    it 'initializes with nothing specified' do
      expect(subject.permissions).to be_empty
    end
  end
end
