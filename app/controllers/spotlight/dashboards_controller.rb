require_dependency "spotlight/application_controller"

module Spotlight
  class DashboardsController < Spotlight::ApplicationController
    include Blacklight::Base

    before_filter :authenticate_user!
    load_resource :exhibit, class: Spotlight::Exhibit

    copy_blacklight_config_from Spotlight::CatalogController

    def show
      @pages = Spotlight::Page.recent.limit(5)
      @solr_documents = load_recent_solr_documents 5

      self.blacklight_config.view.reject! { |k,v| true }
      self.blacklight_config.view.admin_table.partials = ['index_compact']
    end

    def _prefixes
      @_prefixes ||= super + ['spotlight/catalog', 'catalog']
    end

    protected

    def load_recent_solr_documents count
      solr_params = { sort: 'timestamp desc' }
      @response = find(solr_params)
      @response.docs.take(count).map do |doc|
        ::SolrDocument.new(doc, @response)
      end
    end
  end
end
