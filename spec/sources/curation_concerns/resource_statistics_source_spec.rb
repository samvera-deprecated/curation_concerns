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

  describe "embargo_concerns_count" do
    context "when I have concerns" do
      before do
        create :embargoed_work
      end
      it "returns the number of open concerns" do
        expect(described_class.embargo_concerns_count).to eq(1)
      end
    end
  end

  describe "lease_concerns_count" do
    context "when I have concerns" do
      before do
        create :leased_work
      end
      it "returns the number of open concerns" do
        expect(described_class.lease_concerns_count).to eq(1)
      end
    end
  end
end
