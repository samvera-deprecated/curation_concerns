require 'active_triples'

module CurationConcerns
  module Schema
    class WorkMetadata < ActiveTriples::Schema
      property :owner,
               predicate: RDF::URI
                 .intern('http://opaquenamespace.org/ns/hydra/owner'),
               multiple:  false
    end
  end
end
