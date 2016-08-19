module CurationConcerns
  module Admin
    class FeaturesController < Flip::FeaturesController
      before_action do
        authorize! :manage, CurationConcerns::Feature
      end
    end
  end
end
