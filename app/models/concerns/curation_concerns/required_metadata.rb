module CurationConcerns
  module RequiredMetadata
    extend ActiveSupport::Concern

    included do
      apply_schema(CurationConcerns::Schema::RequiredMetadata)

      def first_title
        title.first
      end
    end
  end
end
