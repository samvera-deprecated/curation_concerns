require 'rdf'
module CurationConcerns
  module Vocab
    class HydraProject < RDF::StrictVocabulary('http://opaquenamespace.org/ns/hydra/')
      term :owner, label: 'Owner'.freeze
    end
  end
end
