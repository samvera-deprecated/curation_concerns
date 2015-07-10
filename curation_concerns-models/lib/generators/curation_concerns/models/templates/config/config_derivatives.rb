require 'hydra/works'

CurationConcerns.config do |config|
  # specifies the service to be used by calls invoking
  # Hydra::Derivatives to persist derivative ouput
  config.output_file_service = Hydra::Works::PersistDerivative
end
