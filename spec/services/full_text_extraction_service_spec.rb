require 'spec_helper'

describe CurationConcerns::FullTextExtractionService do
  let(:generic_file) { create(:generic_file) }

  subject { described_class.new(generic_file) }

  before do
    Hydra::Works::UploadFileToGenericFile.call(generic_file, File.open(fixture_file_path('charter.docx')))
  end

  # Integration test to run locally. Actually calls full text extraction machinery.
  it 'extracts fulltext and stores the results' do
    skip 'full text extraction not installed for CI environment' if ENV['CI']
    described_class.run(generic_file)
    # TODO: sort out why extracted_text.content is UTF-8 going in,
    # but after the generic_file.save it is ASCII-8BIT
    #expect(generic_file.extracted_text.content.length).to eq 7235
    
    expect(generic_file.extracted_text.content.class).to eq String
  end

end
