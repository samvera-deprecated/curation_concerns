require 'spec_helper'

describe CurationConcerns::FullTextExtractionService do
  pending "work in progress.  service needs to be separated from characterization"

  subject { described_class.new(generic_file) }
  before do
    Hydra::Works::UploadFileToGenericFile.call(generic_file, File.open(fixture_file_path('charter.docx')))
  end

  it 'extracts fulltext and stores the results' do
    expect(Hydra::Works::FullTextExtractionService).to receive(:run).with(generic_file).and_return('The fulltext')
    expect(generic_file.extracted_text.content).to eq 'The fulltext'
  end

end
