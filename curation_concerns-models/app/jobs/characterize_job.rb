class CharacterizeJob < ActiveFedoraIdBasedJob
  queue_as :characterize

  # Calls characterization, saves the generic_file, and queues a job to create derivatives.
  # Sets original_name property to be same as that of original_file thus over riding characterization.
  def perform(id)
    @id = id
    generic_file.characterize
    generic_file.filename = generic_file.original_file.original_name
    generic_file.save
    CreateDerivativesJob.perform_later(generic_file.id)
  end
end
