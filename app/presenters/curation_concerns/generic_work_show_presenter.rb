module CurationConcerns
  class GenericWorkShowPresenter
    include ModelProxy
    include PresentsAttributes
    attr_accessor :solr_document, :current_ability

    # @param [SolrDocument] solr_document
    # @param [Ability] current_ability
    def initialize(solr_document, current_ability)
      @solr_document = solr_document
      @current_ability = current_ability
    end

    def page_title
      solr_document.title
    end

    # CurationConcern methods
    delegate :stringify_keys, :human_readable_type, :collection?, :representative, :to_s,
             to: :solr_document

    # Metadata Methods
    delegate :title, :description, :creator, :contributor, :subject, :publisher, :language,
             :embargo_release_date, :lease_expiration_date, :rights, to: :solr_document

    def file_presenters
      @generic_files ||= begin
        ids = solr_document.fetch('generic_file_ids_ssim', [])
        PresenterFactory.build_presenters(ids, GenericFilePresenter, current_ability)
      end
    end
  end
end
