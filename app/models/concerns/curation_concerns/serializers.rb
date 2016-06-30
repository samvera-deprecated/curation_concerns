module CurationConcerns
  module Serializers
    def to_s
      if title.present?
        Array.wrap(title).sort.join(' | ')
      elsif label.present?
        Array.wrap(label).sort.join(' | ')
      else
        'No Title'
      end
    end
  end
end
