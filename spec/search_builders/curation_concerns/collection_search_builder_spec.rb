require 'spec_helper'

describe CurationConcerns::CollectionSearchBuilder do
  let(:context) { double('context', blacklight_config: blacklight_config) }
  let(:solr_params) { { fq: [] } }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }

  RSpec.shared_examples 'common SearchBuilder' do
    it { should be_a SearchBuilder }

    describe '#filter_models' do
      it 'adds Collection to :fq' do
        subject.filter_models(solr_params)
        expect(solr_params[:fq].first).to include('{!field f=has_model_ssim}Collection')
      end
    end

    describe '#sort' do
      it 'returns default sort' do
        expect(subject.sort).to eq 'score desc, date_uploaded_dtsi desc'
      end
    end

    describe '#processor_chain' do
      it 'includes methods we override' do
        expect(subject.processor_chain).to include(:add_sorting_to_solr, :filter_models)
      end
    end

    describe '#add_sorting_to_solr' do
      it 'without query, applies default sort' do
        subject.add_sorting_to_solr(solr_params)
        expect(solr_params[:sort]).to eq 'title_si asc'
      end

      it 'with query, does not apply default sort' do
        subject.add_sorting_to_solr(solr_params.merge(q: 'Abraham Lincoln'))
        expect(solr_params[:sort]).not_to eq 'title_si asc'
      end
    end
  end

  describe 'undefined access' do
    subject { described_class.new(context) }
    it_behaves_like 'common SearchBuilder'

    describe '#discovery_permissions' do
      it 'returns the inherited default permissions' do
        expect(subject.discovery_permissions).to contain_exactly('read', 'discover', 'edit')
      end
    end
  end

  describe 'read access' do
    subject { described_class.new(context, ['read']) }
    it_behaves_like 'common SearchBuilder'

    describe '#discovery_permissions' do
      it 'returns the set permissions' do
        expect(subject.discovery_permissions).to eq ['read']
      end
    end
  end

  describe 'edit access' do
    subject { described_class.new(context, ['edit']) }
    it_behaves_like 'common SearchBuilder'

    describe '#discovery_permissions' do
      it 'returns the set permissions' do
        expect(subject.discovery_permissions).to eq ['edit']
      end
    end
  end
end
