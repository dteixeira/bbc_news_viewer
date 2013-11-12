class WebsiteController < ApplicationController

  helpers WebsiteHelpers

  get '/' do
    @params = params
    @title = 'BBC News Search'
    @results = nil

    if params[:searched] and params.size > 1

      # Obtain and escape query.
      query = (params['search-query'] || '*:*').strip
      query = CGI.escape(query)

      # Search setup.
      define_topics
      solr = connect_solr
      q_params = { :q => query }
      default_query_options q_params

      # Advanced search setup.
      advanced_query_options q_params, params, @topics if params['use-selected']

      # Pagination setup.
      page = params[:page] || 1
      page = page.to_i
      result = paginated_solr_query solr, q_params, page
      @n_results = result['response']['numFound']
      @t_query = result['responseHeader']['QTime'] / 1000.0

      # Result binding.
      if result
        @results = paginate_solr_response result, page
      else
        @results = []
      end
    end

    # Render view.
    slim :home
  end
end
