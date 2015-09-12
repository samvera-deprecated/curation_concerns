class CharacterizeJob < ActiveFedoraIdBasedJob
  queue_as :characterize

  def perform(id)
    @id = id
    generic_file.characterize
    generic_file.filename = generic_file.original_file.original_name
    generic_file.save
    CreateDerivativesJob.perform_later(generic_file.id)
  end
end
