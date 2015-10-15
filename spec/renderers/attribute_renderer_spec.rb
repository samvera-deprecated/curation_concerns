require 'spec_helper'

describe AttributeRenderer do
  describe "#render" do
    subject { renderer.render }

    context "with no options" do
      let(:renderer) { described_class.new(:name, ['Bob', 'Jessica']) }

      it { is_expected.to eq "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'><li class=\"attribute name\">Bob</li>\n" \
         "<li class=\"attribute name\">Jessica</li>\n" \
         "</ul></td></tr>" }
    end

    context "with link_to_facet" do
      let(:renderer) { described_class.new(:contributor, values, link_to_facet: 'creator_sim') }
      let(:values) { ['Kathryn', 'Anusha'] }

      it { is_expected.to eq "<tr><th>Contributor</th>\n" \
         "<td><ul class='tabular'><li class=\"attribute contributor\"><a href=\"/catalog?f%5Bcreator_sim%5D%5B%5D=Kathryn\">Kathryn</a></li>\n" \
         "<li class=\"attribute contributor\"><a href=\"/catalog?f%5Bcreator_sim%5D%5B%5D=Anusha\">Anusha</a></li>\n" \
         "</ul></td></tr>" }
    end
  end
end
