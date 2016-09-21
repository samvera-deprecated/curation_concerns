module Sipity
  # A named workflow for processing an entity. Originally I had thought of
  # calling this a Type, but once I extracted the Processing submodule,
  # type felt to much of a noun, not conveying potentiality. Workflow
  # conveys "things will happen" because of this.
  class Workflow < ActiveRecord::Base
    DEFAULT_INITIAL_WORKFLOW_STATE = 'new'.freeze
    self.table_name = 'sipity_workflows'

    has_many :entities, dependent: :destroy
    has_many :workflow_states, dependent: :destroy
    has_many :workflow_actions, dependent: :destroy
    has_many :workflow_roles, dependent: :destroy

    def initial_workflow_state
      workflow_states.find_or_create_by!(name: DEFAULT_INITIAL_WORKFLOW_STATE)
    end
  end
end