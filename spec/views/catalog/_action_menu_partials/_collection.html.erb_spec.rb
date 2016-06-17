require 'spec_helper'

describe 'catalog/_action_menu_partials/_collection.erb' do
  let(:document) { double }
  subject { rendered }

  context "when all the paths are valid" do
    before do
      allow(view).to receive(:can?).and_return(false)
      render 'catalog/_action_menu_partials/collection.html.erb', document: document
    end
    it { is_expected.to include 'Select an action' }
  end
end
