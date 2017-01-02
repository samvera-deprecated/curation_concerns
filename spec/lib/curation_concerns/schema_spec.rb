require 'curation_concerns/schema'

describe CurationConcerns::Schema do
  shared_examples 'a schema' do
    let(:source) { Class.new { include ActiveTriples::RDFSource } }

    it 'applies properties to the source class' do
      expect { source.apply_schema(described_class) }
        .to change { source.properties }.from({})
    end
  end

  describe CurationConcerns::Schema::AdminSetMetadata do
    it_behaves_like 'a schema'
  end

  describe CurationConcerns::Schema::BasicMetadata do
    it_behaves_like 'a schema'
  end

  describe CurationConcerns::Schema::SuppressibleMetadata do
    it_behaves_like 'a schema'
  end

  describe CurationConcerns::Schema::RequiredMetadata do
    it_behaves_like 'a schema'
  end

  describe CurationConcerns::Schema::WorkMetadata do
    it_behaves_like 'a schema'
  end
end
