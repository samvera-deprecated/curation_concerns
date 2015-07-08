module CurationConcerns
  module File
    module Derivatives
      extend ActiveSupport::Concern
      
      included do
        include Hydra::Derivatives
        # This was taken directly from Sufia's GenericFile::Derivatives and modified to exclude any processing that modified the original file
        makes_derivatives do |obj|
          case obj.mime_type
          when 'application/pdf'
            obj.transform_file :original_file, { thumb: '100x100>' }
          when 'audio/wav'
            obj.transform_file :original_file, { mp3: { format: 'mp3' }, ogg: { format: 'ogg'} }, processor: :audio
          when 'video/avi'
            obj.transform_file :original_file, { mp4: { format: 'mp4' }, webm: { format: 'webm'}, thumbnail: { format: 'jpg', datastream: 'thumbnail' } }, processor: :video
          when 'image/png', 'image/jpg'
            obj.transform_file :original_file, { medium: "300x300>", thumb: "100x100>", access: { format: 'jpg', datastream: 'access'} }
          when 'application/vnd.ms-powerpoint'
            obj.transform_file :original_file, { preservation: { format: 'pptx'}, access: { format: 'pdf' }, thumbnail: { format: 'jpg' } }, processor: 'document'
          when 'text/rtf'
            obj.transform_file :original_file, { preservation: { format: 'odf' }, access: { format: 'pdf' }, thumbnail: { format: 'jpg' } }, processor: 'document'
          when 'application/msword'
            obj.transform_file :original_file, { access: { format: 'pdf' }, preservation: { format: 'docx' }, thumbnail: { format: 'jpg' } }, processor: 'document'
          when 'application/vnd.ms-excel'
            obj.transform_file :original_file, { access: { format: 'pdf' }, preservation: { format: 'xslx' }, thumbnail: { format: 'jpg' } }, processor: 'document'
          when 'image/tiff'
            obj.transform_file :original_file, {
              resized: { recipe: :default, resize: "600x600>", datastream: 'resized' },
              config_lookup: { recipe: :default, datastream: 'config_lookup' },
              string_recipe: { recipe: '-quiet', datastream: 'string_recipe' },
              diy: { }
            }, processor: 'jpeg2k_image'
          end
        end
      end
    end
  end
end