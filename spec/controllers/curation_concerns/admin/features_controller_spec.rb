require 'spec_helper'

RSpec.describe CurationConcerns::Admin::FeaturesController do
  routes { CurationConcerns::Engine.routes }

  describe "#index" do
    before do
      sign_in user
    end
    let(:user) { create(:user) }

    context "when not authorized" do
      it "redirects away" do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context "when authorized" do
      before do
        allow_any_instance_of(Ability).to receive(:admin?).and_return(true)
      end
      it "is successful" do
        get :index
        expect(response).to be_success
      end
    end
  end
end
