module CurationConcerns
  module Workflow
    class WorkflowImporter
      module SchemaValidator
        # @param data [Hash]
        # @param schema [#call]
        #
        # @return true if the data validates from the schema
        # @raise Exceptions::InvalidSchemaError if the data does not validate against the schema
        def self.call(data:, schema:)
          validation = schema.call(data)
          return true unless validation.messages.present?
          raise validation.messages.inspect
        end
      end

      # Responsible for generating the work type and corresponding processing entries based on given pathname or JSON document.
      def self.generate_from_json_file(path:, **keywords)
        contents = path.respond_to?(:read) ? path.read : File.read(path)
        data = JSON.parse(contents)
        new(data: data, **keywords).call
      end

      # @param data [#deep_symbolize_keys] the configuration information from which we will generate all the data entries
      # @param schema [#call] The schema in which you will validate the data
      # @param validator [#call] The validation service for the given data and schema
      def initialize(data:, schema: default_schema, validator: default_validator)
        self.data = data
        self.schema = schema
        self.validator = validator
        validate!
      end

      private

        attr_reader :data

        def data=(input)
          @data = input.deep_symbolize_keys
        end

        attr_accessor :validator

        def default_validator
          SchemaValidator.method(:call)
        end

        attr_accessor :schema

        def default_schema
          CurationConcerns::Workflow::WorkflowSchema
        end

        def validate!
          validator.call(data: data, schema: schema)
        end

      public

      def call
        Array.wrap(data.fetch(:work_types)).each do |configuration|
          find_or_create_from(configuration: configuration)
        end
      end

      private

        def find_or_create_from(configuration:)
          workflow = Sipity::Workflow.find_or_create_by!(name: configuration.fetch(:name))
          find_or_create_workflow_permissions!(
            workflow: workflow, workflow_permissions_configuration: configuration.fetch(:workflow_permissions, [])
          )
          generate_state_diagram(workflow: workflow, actions_configuration: configuration.fetch(:actions))
          generate_state_emails(workflow: workflow, state_emails_configuration: configuration.fetch(:state_emails, []))
        end

        extend Forwardable
        def_delegator WorkflowPermissionsGenerator, :call, :find_or_create_workflow_permissions!
        def_delegator SipityActionsGenerator, :call, :generate_state_diagram

        def generate_state_emails(workflow:, state_emails_configuration:)
          Array.wrap(state_emails_configuration).each do |configuration|
            scope = configuration.fetch(:state)
            reason = configuration.fetch(:reason)
            Array.wrap(configuration.fetch(:emails)).each do |email_configuration|
              email_name = email_configuration.fetch(:name)
              recipients = email_configuration.slice(:to, :cc, :bcc)
              EmailNotificationGenerator.call(
                workflow: workflow, scope: scope, email_name: email_name, recipients: recipients, reason: reason
              )
            end
          end
        end
    end
  end
end