module CurationConcerns
  class ResourceStatisticsSource
    class << self
      def open_concerns_count
        # TODO: verify that this is not pulling all records and then counting
        relation.where(Hydra.config.permissions.read.group => 'public').count
      end

      def authenticated_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'registered').count
      end

      def restricted_concerns_count
        # TODO: Replace this with a query that that returns all documents that
        #       either lack the `read_access_group_ssim` key, or have the key
        #       without the values of `public` or `registered`
        relation.count - (authenticated_concerns_count + open_concerns_count)
      end

      def expired_embargo_now_authenticated_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'registered').where("embargo_history_ssim:*").count
      end

      def expired_embargo_now_open_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'public').where("embargo_history_ssim:*").count
      end

      def active_embargo_now_authenticated_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'registered').where("embargo_release_date_dtsi:[NOW TO *]").count
      end

      def active_embargo_now_restricted_concerns_count
        # TODO: Replace the subtraction with another `#where` query that returns
        #       all actively embargoed documents that either lack the
        #       `read_access_group_ssim` key, or have the key without the values
        #       of `public` or `registered`
        relation.where("embargo_release_date_dtsi:[NOW TO *]").count - active_embargo_now_authenticated_concerns_count
      end

      def expired_lease_now_authenticated_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'registered').where("lease_history_ssim:*").count
      end

      def expired_lease_now_restricted_concerns_count
        # TODO: Replace the subtraction with another `#where` query that returns
        #       all expired lease documents that either lack the
        #       `read_access_group_ssim` key, or have the key without the values
        #       of `public` or `registered`
        relation.where("lease_history_ssim:*").count - expired_lease_now_authenticated_concerns_count
      end

      def active_lease_now_authenticated_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'registered').where("lease_expiration_date_dtsi:[NOW TO *]").count
      end

      def active_lease_now_open_concerns_count
        relation.where(Hydra.config.permissions.read.group => 'public').where("lease_expiration_date_dtsi:[NOW TO *]").count
      end

      private

        def relation
          CurationConcerns::WorkRelation.new
        end
    end
  end
end
