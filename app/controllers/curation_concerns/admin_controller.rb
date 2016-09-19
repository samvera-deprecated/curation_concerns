module CurationConcerns
  class AdminController < ApplicationController
    cattr_accessor :configuration
    self.configuration = CurationConcerns.config.dashboard_configuration
    before_action :require_permissions
    before_action :load_configuration
    layout "admin"

    def index
    end

    private

      def require_permissions
        authorize! :read, :admin_dashboard
      end

      def load_configuration
        @configuration = self.class.configuration.with_indifferent_access
      end
  end
end
