require 'active_triples'
require 'curation_concerns/vocab/fedora_resource_status'

module CurationConcerns
  module Schema
    ##
    # Defines a property to hold the workflow state.
    class SuppressibleMetadata < ActiveTriples::Schema
      property :state,
               predicate: CurationConcerns::Vocab::FedoraResourceStatus.objState,
               multiple:  false
    end
  end
end
