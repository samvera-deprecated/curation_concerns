class CharacterizeJob < ActiveJob::Base
  queue_as CurationConcerns.config.ingest_queue_name

  before_perform :wait_for_content # do |job|
  #  byebug
  # end

  DEFAULT_WAIT_TIME = 0.01
  DEFAULT_WAIT_COUNT = 10

  # @param [FileSet] file_set
  # @param [String] filename a local path for the file to characterize. By using this, we don't have to pull a copy out of fedora.
  # @param [Hash] opts hash of options for wait_for_content: :wait_time, :wait_count
  def perform(file_set, filename)
    Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filename)
    file_set.save!
    CreateDerivativesJob.perform_later(file_set, filename)
  end

  def wait_for_content
    count = 0
    until arguments.first.original_file.content
      sleep DEFAULT_WAIT_TIME
      count += 1
      raise(IOError, 'no content found for :original_file') if count == DEFAULT_WAIT_COUNT
    end
  end
end
