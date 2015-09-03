module CurationConcerns
  # Extract the full text from the content using Solr's extract handler
  class FullTextExtractionService
    def self.run(generic_file)
      new(generic_file).extract
    end

    delegate :original_file, :logger, :mime_type, :id, to: :@generic_file

    def initialize(generic_file)
      @generic_file = generic_file
    end

    def extract
      JSON.parse(fetch)[''].rstrip
    rescue => e
      logger.error("Error extracting content from #{id}: #{e.inspect}")
      return nil
    end

    # send the request to the extract service and return the response if it was successful.
    # TODO: this pulls the whole file into memory. We should stream it from Fedora instead
    # @return [String] the result of calling the extract service
    def fetch
      req = Net::HTTP.new(uri.host, uri.port)
      resp = req.post(uri.to_s, original_file.content, request_headers)
      fail "URL '#{uri}' returned code #{resp.code}" unless resp.code == '200'
      original_file.content.rewind if original_file.content.respond_to?(:rewind)

      resp.body
    end

    # @return [Hash] the request headers to send to the Solr extract service
    def request_headers
      { Rack::CONTENT_TYPE => "#{mime_type};charset=utf-8",
        Rack::CONTENT_LENGTH => original_file.size.to_s }
    end

    # @returns [URI] path to the extract service
    def uri
      @uri ||= connection_url + "/update/extract?extractOnly=true&wt=json&extractFormat=text"
    end

    def connection_url
      Blacklight.default_index.connection.uri
    end
  end
end
