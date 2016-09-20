require 'spec_helper'

describe 'curation_concerns/admin/_total_objects.html.erb', type: :view do
  before do
    assign(:configuration, configuration)
  end
  let(:stat_class) { class_double(CurationConcerns::ResourceStatisticsSource, open_concerns_count: 25,
                                                                              authenticated_concerns_count: 300,
                                                                              restricted_concerns_count: 777,
                                                                              expired_embargo_now_authenticated_concerns_count: 66,
                                                                              expired_embargo_now_open_concerns_count: 77,
                                                                              active_embargo_now_authenticated_concerns_count: 88,
                                                                              active_embargo_now_restricted_concerns_count: 99,
                                                                              expired_lease_now_authenticated_concerns_count: 6666,
                                                                              expired_lease_now_restricted_concerns_count: 7777,
                                                                              active_lease_now_authenticated_concerns_count: 8888,
                                                                              active_lease_now_open_concerns_count: 9999) }
  let(:configuration) { { data_sources: { resource_stats: stat_class } } }

  it "renders without error" do
    render
    expect(rendered).to have_content("Visibility Open Access (25)")
    expect(rendered).to have_content("Institution Name (300)")
    expect(rendered).to have_content("Private (777)")
    expect(rendered).to have_content("Embargo (Expired, Authenticated) (66)")
    expect(rendered).to have_content("Lease (Active, Authenticated) (8888)")
  end
end
