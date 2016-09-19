module CurationConcerns
  class AdminController < ApplicationController
    cattr_accessor :configuration
    self.configuration = CurationConcerns.config.dashboard_configuration
    before_action :require_permissions

    def index
    end

    private

      def require_permissions
        authorize! :read, :admin_dashboard
      end
  end
end
