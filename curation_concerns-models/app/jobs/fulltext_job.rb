class FulltextJob < ActiveFedoraIdBasedJob
  queue_as :fulltext

  def perform(id)
    @id = id
    CurationConcerns::CharacterizationService.run(generic_file)
    generic_file.save
  end
end
