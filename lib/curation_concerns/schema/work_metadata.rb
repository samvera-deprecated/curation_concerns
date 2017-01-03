require 'active_triples'

module CurationConcerns
  module Schema
    class WorkMetadata < ActiveTriples::Schema
      property :owner,
               predicate: Vocab::HydraProject.owner,
               multiple:  false
    end
  end
end
