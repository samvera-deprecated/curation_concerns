module CurationConcerns
  class Feature < ActiveRecord::Base
    extend Flip::Declarable

    strategy Flip::CookieStrategy
    strategy Flip::DatabaseStrategy
    strategy Flip::DeclarationStrategy
    default false

    feature :assign_admin_set,
            default: true,
            description: "Ability to assign uploaded items to an admin set"
  end
end
