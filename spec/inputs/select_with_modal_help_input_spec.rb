require 'spec_helper'

describe 'SelectWithModalHelpInput', type: :input do
  before do
    qa_fixtures = { local_path: File.expand_path('../../fixtures/authorities', __FILE__) }
    stub_const("Qa::Authorities::LocalSubauthority::AUTHORITIES_CONFIG", qa_fixtures)
  end

  subject { input_for file, :rights, options }
  let(:file) { FileSet.new }
  let(:base_options) { { as: :select_with_modal_help, required: true, collection: RightsService.select_active_options } }
  let(:options) { base_options }

  context "when a blank is requested" do
    let(:options) { base_options.merge(include_blank: true) }
    it 'renders a blank option' do
      expect(subject).to have_selector 'select option[value=""]'
    end
  end

  context "when a blank is not requested" do
    it 'has no blanks' do
      expect(subject).to have_selector 'select option:first-child', text: 'First Active Term'
    end
  end

  context "when inactive rights are associated with a work" do
    before do
      file.rights = ['demo_id_04']
    end

    it 'will attach an option with a data-attribute of force-label' do
      expect(subject).to have_xpath('//select[1][@data-force-label="Fourth is an Inactive Term"]')
      expect(subject).not_to have_xpath('//select[2][@data-force-label="Fourth is an Inactive Term"]')
    end

    it 'will attach an option with a data-attribute of force-value' do
      expect(subject).to have_xpath('//select[1][@data-force-value="demo_id_04"]')
      expect(subject).not_to have_xpath('//select[2][@data-force-value="demo_id_04"]')
    end

    it 'will attach an option with a class of inactive-rights' do
      expect(subject).to have_css 'select.force-select'
    end
  end
end
