require 'spec_helper'

describe FulltextJob do
  let(:generic_file) { GenericFile.new(id: generic_file_id) }
  let(:generic_file_id) { 'abc123' }

  before do
    allow(ActiveFedora::Base).to receive(:find).with(generic_file_id).and_return(generic_file)
  end

  it 'runs FulltextService that spawns a CreateDerivativesJob' do
    expect(Hydra::Works::FullTextExtractionService).to receive(:run).with(generic_file)
    expect(generic_file).to receive(:save)
    described_class.perform_now generic_file_id
  end
end
