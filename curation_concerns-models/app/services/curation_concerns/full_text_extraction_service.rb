module CurationConcerns
  class FullTextExtractionService
    def self.run(generic_file)
      extract_store_fulltext(generic_file)
    end

    def self.extract_store_fulltext(generic_file)
      extracted_text = Hydra::Works::FullTextExtractionService.run(generic_file)
      return unless extracted_text.present?
      extracted_text_file = generic_file.build_extracted_text
      extracted_text_file.content = extracted_text
      generic_file.save
    end
  end
end
