require 'spec_helper'

RSpec.describe CurationConcerns::Admin::StrategiesController do
  routes { CurationConcerns::Engine.routes }

  describe "#update" do
    before do
      sign_in user
    end
    let(:user) { create(:user) }

    context "when not authorized" do
      it "redirects away" do
        patch :update, params: { feature_id: '123', id: 'database' }
        expect(response).to redirect_to root_path
      end
    end

    context "when authorized" do
      before do
        allow_any_instance_of(Ability).to receive(:admin?).and_return(true)
      end
      it "is successful" do
        patch :update, params: { feature_id: '123', id: 'database' }
        expect(response).to redirect_to admin_features_path
      end
    end
  end
end
