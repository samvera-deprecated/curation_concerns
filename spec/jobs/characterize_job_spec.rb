require 'spec_helper'
require 'support/generic_file_helper'

describe CharacterizeJob do
  let(:generic_file_id) { 'abc123' }
  let(:generic_file) { GenericFile.new(id: generic_file_id) }
  let(:file)         { Hydra::PCDM::File.new { |f| f.original_name = "demoname" } }

  before do
    mock_add_file_to_generic_file(generic_file, file)
    allow(ActiveFedora::Base).to receive(:find).with(generic_file_id).and_return(generic_file)
  end

  it 'runs CurationConcerns::CharacterizationService that spawns a CreateDerivativesJob' do
    expect(generic_file).to receive(:characterize)
    expect(generic_file).to receive(:save)
    expect(CreateDerivativesJob).to receive(:perform_later).with(generic_file_id)
    described_class.perform_now generic_file_id
  end
end
