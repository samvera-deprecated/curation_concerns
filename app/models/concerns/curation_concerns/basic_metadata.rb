module CurationConcerns
  module BasicMetadata
    extend ActiveSupport::Concern

    included do
      apply_schema(CurationConcerns::Schema::BasicMetadata)
    end
  end
end
