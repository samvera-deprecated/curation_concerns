require 'sufia/models'
module Worthwhile
  module Models
    class Engine < ::Rails::Engine
      config.autoload_paths += %W(
       #{config.root}/app/actors/concerns
      )
    end
  end
end

module CurationConcerns
  module Models
    class Engine < ::Rails::Engine
      initializer 'requires' do
        require 'active_fedora/noid'
        require 'curation_concerns/noid'
      end
    end
  end
end