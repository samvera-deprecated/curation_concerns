require 'spec_helper'

describe CurationConcerns::CollectionSearchBuilder do
  let(:context) { double('context') }
  let(:solr_params) { { fq: [] } }

  subject { described_class.new(context, :read) }
  describe '#filter_models' do
    before { subject.filter_models(solr_params) }

    it 'adds Collection to :fq' do
      expect(solr_params[:fq].first).to include('{!field f=has_model_ssim}Collection')
    end
  end
end
