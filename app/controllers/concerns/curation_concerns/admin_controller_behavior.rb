module CurationConcerns
  module AdminControllerBehavior
    extend ActiveSupport::Concern

    included do
      include Blacklight::Catalog
      cattr_accessor :configuration
      self.configuration = CurationConcerns.config.dashboard_configuration
      before_action :require_permissions
      before_action :load_configuration
      layout "admin"
      copy_blacklight_config_from ::CatalogController
      configure_blacklight do |config|
        config.view.aggregate.partials = [:aggregate_information]
      end
      def index
        render "index"
      end

      def search
        (@response, @document_list) = search_results(params)
        @search_builder = search_builder.with(params)

        respond_to do |format|
          format.html do
            store_preferred_view
            render "index"
          end
          additional_response_formats(format)
          document_export_formats(format)
        end
      end

      def _prefixes
        @_prefixes ||= super + ['catalog/']
      end

      def search_action_url(options = {})
        admin_catalog_url(options.except(:controller, :action))
      end
    end

    private

      def require_permissions
        authorize! :read, :admin_dashboard
      end

      def load_configuration
        @configuration = self.class.configuration.with_indifferent_access
      end

      ##
      # Loads the index action if it's only defined in the configuration.
      def action_missing(action)
        index if @configuration[:actions].include?(action)
      end
  end
end
