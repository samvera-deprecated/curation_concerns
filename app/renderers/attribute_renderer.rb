class AttributeRenderer
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  include Blacklight::UrlHelperBehavior
  include Blacklight::FacetsHelperBehavior
  attr_reader :field, :values, :options

  # @param [Symbol] field
  # @param [Array] values
  # @param [Hash] options
  # @option options [TrueClass, FalseClass] :include_empty
  # @option options [String] :link_to_facet
  # @option options [TrueClass, FalseClass] :catalog_search_link
  def initialize(field, values, options = {})
    @field = field
    @values = values
    @options = options
  end

  # Draw the table row for the attribute
  def render
    markup = ''

    return markup if !values.present? && !options[:include_empty]
    markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
    Array(values).each do |value|
      markup << %(<li class="attribute #{field}">#{attribute_value_to_html(value)}</li>\n)
    end
    markup << %(</ul></td></tr>)
    markup.html_safe
  end

  private

    def label
      translate(
        :"blacklight.search.fields.show.#{field}",
        default: [:"blacklight.search.fields.#{field}", options.fetch(:label, field.to_s.humanize)])
    end

    def attribute_value_to_html(value)
      if field == :rights
        rights_attribute_to_html(value)
      else
        li_value(value)
      end
    end

    def search_field
      options.fetch(:search_field, field)
    end

    def li_value(value)
      if options[:catalog_search_link]
        link_to ERB::Util.h(value), search_path(value)
      elsif options[:link_to_facet]
        link_to ERB::Util.h(value), facet_path(value, options[:link_to_facet])
      else
        ERB::Util.h(value)
      end
    end

    def search_path(value)
      Rails.application.routes.url_helpers.catalog_index_path(
        search_field: search_field, q: ERB::Util.h(value))
    end

    def facet_path(value, facet_field)
      Rails.application.routes.url_helpers.catalog_index_path(
        add_facet_params(facet_field, value)
      )
    end

    # used by add_facet_params
    def params
      {}
    end

    delegate :blacklight_config, to: CatalogController

    ##
    # Special treatment for license/rights.  A URL from the Sufia gem's config/sufia.rb is stored in the descMetadata of the
    # curation_concern.  If that URL is valid in form, then it is used as a link.  If it is not valid, it is used as plain text.
    def rights_attribute_to_html(value)
      begin
        parsed_uri = URI.parse(value)
      rescue
        nil
      end
      if parsed_uri.nil?
        ERB::Util.h(value)
      else
        %(<a href=#{ERB::Util.h(value)} target="_blank">#{RightsService.label(value)}</a>)
      end
    end
end
