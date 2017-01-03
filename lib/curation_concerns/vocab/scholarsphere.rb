require 'rdf'
module CurationConcerns
  module Vocab
    class Scholarsphere < RDF::StrictVocabulary('http://scholarsphere.psu.edu/ns#')
      term :importUrl,    label: 'Import URL'.freeze
      term :relativePath, label: 'Relative Path'.freeze
    end
  end
end
