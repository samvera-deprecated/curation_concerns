module CurationConcerns
  # Workflow considerations
  module Suppressible
    extend ActiveSupport::Concern

    included do
      # This holds the workflow state
      property :state, predicate: Vocab::FedoraResourceStatus.objState, multiple: false
    end

    def deactivate
      self.state = Vocab::FedoraResourceStatus.inactive
    end

    def activate
      self.state = Vocab::FedoraResourceStatus.active
    end

    # Override this method if you have some criteria by which records should not
    # display in the search results.
    def suppressed?
      state == Vocab::FedoraResourceStatus.inactive
    end

    def to_sipity_entity
      raise "Can't create an entity until the model has been persisted" unless persisted?
      @sipity_entity ||= Sipity::Entity.find_by(proxy_for_global_id: to_global_id.to_s)
    end
  end
end
