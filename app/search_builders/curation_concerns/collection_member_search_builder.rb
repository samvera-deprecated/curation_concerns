module CurationConcerns
  class CollectionMemberSearchBuilder < CurationConcerns::MemberSearchBuilder
    include CurationConcerns::FilterByType
    include CurationConcerns::FilterSuppressed
  end
end
