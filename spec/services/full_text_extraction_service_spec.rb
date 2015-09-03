require 'spec_helper'

describe CurationConcerns::FullTextExtractionService do
  describe "run" do
    before do
      allow_any_instance_of(described_class).to receive(:fetch).and_return('{"":"one two three"}')
    end

    let(:generic_file) { double }
    subject { described_class.run(generic_file) }

    it { is_expected.to eq 'one two three' }
  end

  describe "fetch" do
    let(:generic_file) { double('generic file', original_file: original, mime_type: 'text/plain') }
    let(:original) { double(content: content, size: 13) }
    let(:service) { described_class.new(generic_file) }
    subject { service.fetch }
    let(:request) { double }
    let(:response_body) { double }
    let(:resp) { double(code: '200', body: response_body) }
    let(:uri) { URI('http://example.com:99/solr/update') }
    let(:content) { 'file contents' }

    before do
      allow(service).to receive(:uri).and_return(URI('http://example.com:99/solr/update'))
      allow(Net::HTTP).to receive(:new).with('example.com', 99).and_return(request)
    end

    it "points at the extraction service" do
      expect(request).to receive(:post).with('http://example.com:99/solr/update', content, "Content-Type" => "text/plain;charset=utf-8", "Content-Length" => "13").and_return(resp)
      expect(subject).to eq response_body
    end
  end

  describe "uri" do
    let(:generic_file) { double }
    let(:service) { described_class.new(generic_file) }
    subject { service.uri }

    it "points at the extraction service" do
      expect(subject).to be_kind_of URI
      expect(subject.to_s).to end_with '/update/extract?extractOnly=true&wt=json&extractFormat=text'
    end
  end
end
