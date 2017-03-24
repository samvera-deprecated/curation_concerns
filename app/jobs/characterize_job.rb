class CharacterizeJob < ActiveJob::Base
  include CurationConcerns::Lockable

  queue_as CurationConcerns.config.ingest_queue_name

  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the CurationConcerns.config.working_path
  def perform(file_set, file_id, filepath = nil)
    filename = CurationConcerns::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath)
    raise LoadError, "#{file_set.class.characterization_proxy} was not found" unless file_set.characterization_proxy?

    # Prevent other jobs from trying to modify the FileSet at the same time
    acquire_lock_for(file_set.id) do
      Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filename)
      Rails.logger.debug "Ran characterization on #{file_set.characterization_proxy.id} (#{file_set.characterization_proxy.mime_type})"
      file_set.characterization_proxy.save!
      file_set.update_index
      file_set.parent.in_collections.each(&:update_index) if file_set.parent
    end

    CreateDerivativesJob.perform_now(file_set, file_id, filename)
  end
end
