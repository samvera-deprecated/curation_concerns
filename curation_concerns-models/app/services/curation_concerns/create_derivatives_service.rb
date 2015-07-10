module CurationConcerns
  class CreateDerivativesService

    def self.run(generic_file)
      generic_file.create_derivatives
    end

  end
end
