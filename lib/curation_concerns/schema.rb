module CurationConcerns
  module Schema
    autoload :AdminSetMetadata,     'curation_concerns/schema/admin_set_metadata'
    autoload :BasicMetadata,        'curation_concerns/schema/basic_metadata'
    autoload :RequiredMetadata,     'curation_concerns/schema/required_metadata'
    autoload :WorkMetadata,         'curation_concerns/schema/work_metadata'
    autoload :SuppressibleMetadata, 'curation_concerns/schema/suppressible_metadata'
  end
end
