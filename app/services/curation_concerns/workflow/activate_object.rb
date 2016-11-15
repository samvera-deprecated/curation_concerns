module CurationConcerns
  module Workflow
    class ActivateObject
      def self.call(target:, **)
        target.activate
      end
    end
  end
end
