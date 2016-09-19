require 'spec_helper'

feature 'admin dashboard' do
  let(:user) { FactoryGirl.create(:user) }
  context "when given permission" do
    before do
      allow_any_instance_of(CurationConcerns::AdminController).to receive(:authorize!).with(:read, :admin_dashboard).and_return(true)
    end
    it "renders" do
      visit "/admin"
    end
  end
end
