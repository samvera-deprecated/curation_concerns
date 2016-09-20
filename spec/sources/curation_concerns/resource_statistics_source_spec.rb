require 'spec_helper'

describe CurationConcerns::ResourceStatisticsSource do
  describe "open_concerns_count" do
    it "returns the number of open concerns" do
      expect(described_class.open_concerns_count).to eq(0)
    end

    context "when I have concerns" do
      before do
        create :public_generic_work
      end
      it "returns the number of open concerns" do
        expect(described_class.open_concerns_count).to eq(1)
      end
    end
  end

  describe "registered_concerns_count" do
    context "when I have concerns" do
      before do
        create :authenticated_generic_work
      end
      it "returns the number of open concerns" do
        expect(described_class.authenticated_concerns_count).to eq(1)
      end
    end
  end

  describe "restricted_concerns_count" do
    context "when I have concerns" do
      before do
        create :generic_work
      end
      it "returns the number of open concerns" do
        expect(described_class.restricted_concerns_count).to eq(1)
      end
    end
  end

  describe "embargo" do
    before do
      create :embargoed_work, embargo_date: embargo_date, current_state: current_state, future_state: future_state
    end

    describe "#active_embargo_now_authenticated_concerns_count" do
      let(:embargo_date) { Date.tomorrow.to_s }
      let(:current_state) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      let(:future_state) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

      it "returns the number of embargo concerns" do
        expect(described_class.active_embargo_now_authenticated_concerns_count).to eq(1)
      end
    end

    describe "#expired_embargo_now_authenticated_concerns_count" do
      let(:embargo_date) { Date.yesterday.to_s }
      let(:current_state) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      let(:future_state) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }

      it "returns the number of embargo concerns" do
        expect(described_class.expired_embargo_now_authenticated_concerns_count).to eq(1)
      end
    end
  end
end
