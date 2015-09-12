module CurationConcerns
  class CharacterizationService
    def self.run(generic_file)
      generic_file.characterize
      generic_file.filename = generic_file.original_file.original_name
    end
  end
end
