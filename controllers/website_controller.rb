class WebsiteController < ApplicationController

  helpers WebsiteHelpers

  get '/' do
    @params = params
    @title = 'BBC News Search'

    # Search setup.
    define_topics
    solr = connect_solr
    q_params = { :q => 'text:"manchester united"' }
    default_query_options q_params
    page = params[:page] || 1
    page = page.to_i
    result = paginated_solr_query solr, q_params, page

    # Result binding.
    if result
      @results = paginate_solr_response result, page
    else
      @results = []
    end

    # Render view.
    slim :home
  end
end
