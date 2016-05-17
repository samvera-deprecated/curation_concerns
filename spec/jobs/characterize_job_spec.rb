require 'spec_helper'

describe CharacterizeJob do
  let(:file_set)      { FileSet.new(id: file_set_id) }
  let(:file_set_id)   { 'abc123' }
  let(:filename)      { double }
  let(:original_file) { mock_model('MockFile') }

  before do
    allow(file_set).to receive(:original_file).and_return(original_file)
    allow(FileSet).to receive(:find).with(file_set_id).and_return(file_set)
  end

  context 'when original file is present' do
    before { allow(original_file).to receive(:content).and_return('stuff') }
    it 'runs Hydra::Works::CharacterizationService and creates a CreateDerivativesJob' do
      expect(Hydra::Works::CharacterizationService).to receive(:run).with(original_file, filename)
      expect(file_set).to receive(:save!)
      expect(CreateDerivativesJob).to receive(:perform_later).with(file_set, filename)
      described_class.perform_now file_set, filename
    end
  end

  context 'when original file is not present' do
    let(:job) { described_class.new(file_set, filename) }
    before { allow(original_file).to receive(:content).and_return(nil) }
    it 'waits for the file then fails after a number of tries' do
      expect(job).to receive(:sleep).with(described_class::DEFAULT_WAIT_TIME).exactly(described_class::DEFAULT_WAIT_COUNT).times
      expect { job.perform_now }.to raise_error(IOError, 'no content found for :original_file')
    end
  end
end
