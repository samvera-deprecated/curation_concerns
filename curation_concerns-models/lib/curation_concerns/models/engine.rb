require 'sufia/models'
module CurationConcerns
  module Models
    class Engine < ::Rails::Engine
      config.autoload_paths += %W(
       #{config.root}/app/actors/concerns
      )
    end
  end
end

