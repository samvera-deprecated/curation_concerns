class IngestFileJob < ActiveJob::Base
  queue_as :ingest

  def perform(file_set_id, filename, mime_type, user_key)
    file_set = FileSet.find(file_set_id)
    file = Hydra::Derivatives::IoDecorator.new(File.open(filename, "rb"))
    file.mime_type = mime_type
    file.original_name = File.basename(filename)

    # Assign label and title of File Set after original_name has been determined.
    file_set.label ||= file.original_filename
    file_set.title = [file_set.label] if file_set.title.blank?

    # Tell UploadFileToGenericFile service to skip versioning because versions will be minted by VersionCommitter (called by save_characterize_and_record_committer) when necessary
    Hydra::Works::UploadFileToFileSet.call(file_set, file, versioning: false)
    file_set.save!
    user = User.find_by_user_key(user_key)
    CurationConcerns::VersioningService.create(file_set.original_file, user)
    CurationConcerns.config.callback.run(:after_create_content, file_set, user)
  end
end
