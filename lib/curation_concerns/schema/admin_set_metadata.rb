require 'active_triples'

require 'rdf/vocab/dc'
require 'rdf/vocab/dc11'

module CurationConcerns
  module Schema
    class AdminSetMetadata < ActiveTriples::Schema
      property :title, predicate: ::RDF::Vocab::DC.title do |index|
        index.as :stored_searchable, :facetable
      end

      property :description, predicate: ::RDF::Vocab::DC.description do |index|
        index.as :stored_searchable
      end

      property :creator, predicate: ::RDF::Vocab::DC11.creator do |index|
        index.as :symbol
      end
    end
  end
end
