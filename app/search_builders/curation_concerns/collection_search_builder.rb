module CurationConcerns
  # Our parent class is the generated SearchBuilder descending from Blacklight::SearchBuilder
  # It includes Blacklight::Solr::SearchBuilderBehavior, Hydra::AccessControlsEnforcement, CurationConcerns::SearchFilters
  # @see https://github.com/projectblacklight/blacklight/blob/master/lib/blacklight/search_builder.rb Blacklight::SearchBuilder parent
  # @see https://github.com/projectblacklight/blacklight/blob/master/lib/blacklight/solr/search_builder_behavior.rb Blacklight::Solr::SearchBuilderBehavior
  # @see https://github.com/projecthydra/curation_concerns/blob/master/app/search_builders/curation_concerns/README.md SearchBuilders README
  # @note the default_processor_chain defined by Blacklight::Solr::SearchBuilderBehavior provides many possible points of override
  #
  class CollectionSearchBuilder < ::SearchBuilder
    include FilterByType

    # Defines which search_params_logic should be used when searching for Collections
    # @param [#blacklight_config, #current_ability] scope the object that has access to #blacklight_config
    #   From a controller, scope would be `self`.  This argument is passed to ::SearchBuilder.new()
    # @note permissions will otherwise be defaulted by inherited #discovery_permissions
    # @see @discovery_permissions
    def initialize(context)
      @rows = 100
      super(context)
    end

    # @!group Overrides
    #
    # @return [Class] ActiveFedora model(s) indexed in Solr has_model_ssim field
    def models
      [::Collection]
    end

    # @return [String] Solr field name indicating default sort order
    def sort_field
      Solrizer.solr_name('title', :sortable)
    end

    # @!endgroup

    private

      # @return [Hash{Symbol => Array[Symbol]}] bottom-up map of "what you need" to "what qualifies"
      # @note i.e., requiring :read access is satisfied by either :read or :edit access
      def access_levels
        { read: [:read, :edit], edit: [:edit] }
      end
  end
end
