require 'spec_helper'

describe 'Characterization' do
  let(:generic_file) { create(:generic_file) }
  #TODO mock out generic file such that it has original_file
  #TODO mock out original_file such that it has original_name

  describe '#run' do
    let(:service_instance) { double }
    before do
      allow(generic_file).to receive(:characterize).and_return(generic_file)
      allow(generic_file).to receive(:save).and_return(generic_file)
    end
    it 'calls .characterize on the generic file' do
      expect(generic_file).to receive(:characterize)
      described_class.run(generic_file)
    end

    it 'calls .save on the generic file' do
      expect(generic_file).to receive(:save)
      described_class.run(generic_file)
    end
  end

end
