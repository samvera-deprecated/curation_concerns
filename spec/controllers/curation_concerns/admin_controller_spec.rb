require 'spec_helper'

RSpec.describe CurationConcerns::AdminController do
  routes { CurationConcerns::Engine.routes }
  describe "GET /admin" do
    context "when you have permission" do
      let(:user) { FactoryGirl.create(:admin) }
      before do
        allow(controller).to receive(:authorize!).with(:read, :admin_dashboard).and_return(true)
      end
      it "works" do
        get :index
        expect(response).to be_success
      end
    end
    context "when they don't have permission" do
      it "throws a CanCan error" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
