module CurationConcerns
  module Workflow
    # This is a built in function for workflow, so that a workflow action can be created that
    # deactivates an object.
    class DeactivateObject
      def self.call(target:, **)
        target.deactivate
      end
    end
  end
end
