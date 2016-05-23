class SelectWithModalHelpInput < MultiValueWithHelpInput
  def link_to_help
    template.link_to "##{attribute_name}Modal", id: "#{input_class}_help_modal", rel: 'button',
                                                data: { toggle: 'modal' }, 'aria-label' => aria_label do
      help_icon
    end
  end

  private

    def select_options
      @select_options ||= begin
        collection = options.delete(:collection) || self.class.boolean_collection
        collection.respond_to?(:call) ? collection.call : collection.to_a
      end
    end

    def build_field(value, _index)
      html_options = input_html_options.dup

      if @rendered_first_element
        html_options[:id] = nil
        html_options[:required] = nil
      else
        html_options[:id] ||= input_dom_id
      end
      html_options[:class] ||= []
      html_options[:class] += ["#{input_dom_id} form-control multi-text-field"]
      html_options[:'aria-labelledby'] = label_id
      html_options.delete(:multiple)
      @rendered_first_element = true

      html_options.merge!(options.slice(:include_blank))
      html_options = add_force_option_data_to_html_options(value, html_options)
      template.select_tag(attribute_name, template.options_for_select(select_options, value), html_options)
    end

    def add_force_option_data_to_html_options(value, html_options)
      return html_options if value.blank? || RightsService.active?(value)
      html_options.tap do |opts|
        opts[:class] << ' force-select'
        opts[:'data-force-label'] = RightsService.label(value)
        opts[:'data-force-value'] = value
      end
    end
end
