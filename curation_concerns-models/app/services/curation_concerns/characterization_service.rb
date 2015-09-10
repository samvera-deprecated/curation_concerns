module CurationConcerns
  # Run FITS to gather technical metadata about the content and the full text.
  # Store this extracted metadata in the characterization datastream.
  class CharacterizationService

    def self.run(generic_file)
      #new(generic_file).characterize
      generic_file.characterize
      # store_metadata(extract_metadata) # done by hydra-works now
      extract_store_fulltext(generic_file)
      generic_file.filename = generic_file.original_file.original_name
    end

    protected

      def self.extract_store_fulltext(generic_file)
        extracted_text = Hydra::Works::FullTextExtractionService.run(generic_file)
        return unless extracted_text.present?
        extracted_text_file = generic_file.build_extracted_text
        extracted_text_file.content = extracted_text
      end
  end
end
