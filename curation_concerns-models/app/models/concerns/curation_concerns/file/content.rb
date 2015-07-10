module CurationConcerns
  module File
    module Content
      extend ActiveSupport::Concern

      included do
        directly_contains_one :webm, through: :files, type: ::RDF::URI("http://pcdm.org/use#webm"), class_name: "Hydra::PCDM::File"
        directly_contains_one :mp4, through: :files, type: ::RDF::URI("http://pcdm.org/use#mp4"), class_name: "Hydra::PCDM::File"
        directly_contains_one :mp3, through: :files, type: ::RDF::URI("http://pcdm.org/use#mp3"), class_name: "Hydra::PCDM::File"
        directly_contains_one :ogg, through: :files, type: ::RDF::URI("http://pcdm.org/use#ogg"), class_name: "Hydra::PCDM::File"
        directly_contains_one :preservation, through: :files, type: ::RDF::URI("http://pcdm.org/use#preservation"), class_name: "Hydra::PCDM::File"
        directly_contains_one :access, through: :files, type: ::RDF::URI("http://pcdm.org/use#access"), class_name: "Hydra::PCDM::File"
      end

    end
  end
end
