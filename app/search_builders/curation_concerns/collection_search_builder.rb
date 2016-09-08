module CurationConcerns
  # Our parent class is the generated SearchBuilder descending from Blacklight::SearchBuilder.
  # Defines search_params_logic used when searching for Collections.
  # @see https://github.com/projecthydra/curation_concerns/blob/master/app/search_builders/curation_concerns/README.md SearchBuilders README
  #
  class CollectionSearchBuilder < ::SearchBuilder
    # @param [#blacklight_config, #current_ability] scope the object that has access to #blacklight_config
    #   From a controller, scope would be `self`.  This argument passed to ::SearchBuilder.new()
    # @param [Symbol] permissions defining breadth of search, e.g. :edit, :read
    # @note permissions will otherwise be defaulted by inherited #discovery_permissions
    def initialize(scope, access = nil)
      @rows = 100
      @discovery_permissions ||= access_levels[access] if access
      super(scope)
    end

    # @return [String] class URI of the model, as indexed in Solr has_model_ssim field
    def model_class_uri
      ::Collection.to_class_uri
    end

    # @return [String] Solr field name indicating default sort order
    def sort_field
      'title_si'
    end

    # @return [Hash{Symbol => Array[Symbol]}] bottom-up map of "what you need" to "what qualifies"
    # @note i.e., requiring :read access is satisfied by either :read or :edit access
    def access_levels
      { read: [:read, :edit], edit: [:edit] }
    end

    # @!group Overrides
    #
    # This overrides the filter_models in FilterByType
    def filter_models(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << ActiveFedora::SolrQueryBuilder.construct_query_for_rel(has_model: model_class_uri)
    end

    # Sort results by title if no query was supplied.
    # This overrides the default 'relevance' sort.
    def add_sorting_to_solr(solr_parameters)
      return if solr_parameters[:q]
      solr_parameters[:sort] ||= "#{sort_field} asc"
    end
  end
end
