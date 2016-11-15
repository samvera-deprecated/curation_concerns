module CurationConcerns
  class WorkSearchBuilder < ::SearchBuilder
    include CurationConcerns::SingleResult
    include CurationConcerns::FilterSuppressed

    # work show page should not filter out suppressed works set by the base search builder used for catalog searches
    self.default_processor_chain -= [:only_active_works]
  end
end
