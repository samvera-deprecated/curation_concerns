module CurationConcerns
  class SolrDocumentPresenterBase
    attr_accessor :solr_document

    # @param [SolrDocument] solr_document
    def initialize(solr_document)
      @solr_document = solr_document
    end
  end
end
