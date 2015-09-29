class FulltextJob < ActiveFedoraIdBasedJob
  queue_as :fulltext

  def perform(id)
    @id = id
    CurationConcerns::FullTextExtractionService.run(generic_file)
    generic_file.save
  end
end
