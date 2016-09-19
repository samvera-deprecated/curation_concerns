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
        relation.count - (authenticated_concerns_count + open_concerns_count)
      end

      def expired_embargo_now_authenticated_concerns_count
      end

      def expired_embargo_now_open_concerns_count
      end

      def active_embargo_now_authenticated_concerns_count
      end

      def active_embargo_now_restricted_concerns_count
      end

      def expired_lease_now_authenticated_concerns_count
      end

      def expired_lease_now_restricted_concerns_count
      end

      def active_lease_now_authenticated_concerns_count
      end

      def active_lease_now_open_concerns_count
      end

      private

        def relation
          CurationConcerns::WorkRelation.new
        end
    end
  end
end
