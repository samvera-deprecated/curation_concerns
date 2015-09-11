module CurationConcerns
  class CharacterizationService
    def self.run(generic_file)
      generic_file.characterize
      generic_file.filename = generic_file.original_file.original_name
      # TODO call to save is wiping properties.  engine_cart:regenerate
      # generic_file.save
    end
  end
end
