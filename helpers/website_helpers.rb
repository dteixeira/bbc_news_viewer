module WebsiteHelpers

  # Defines a Solr server connection instance.
  def connect_solr
    RSolr.connect :url => ApplicationController::SOLR_SERVER
  end

  # Defines topics key to text conversion.
  def define_topics
    @topics = {
      'uk' => 'UK',
      'world' => 'World',
      'education' => 'Education',
      'politics' => 'Politics',
      'health' => 'Health',
      'science_and_environment' => 'Science and Environment',
      'business' => 'Business',
      'technology' => 'Technology',
      'entertainment_and_arts' => 'Entertainment and Arts'
    }
  end

  # Makes a paginated Solr query.
  def paginated_solr_query solr, params = { q: '*:*' }, page = 1, per_page = ApplicationController::SOLR_RESULTS_PER_PAGE
    params[:start] = (page - 1) * per_page
    response = solr.get 'select', params: params rescue response = nil

    # Replace fields with highlighting.
    if response != nil && response['highlighting'] != nil
      response['response']['docs'].each do |doc|
        h = response['highlighting'][doc['id']]
        if h != nil
          doc['title'] = h['title'][0] if h['title']
          doc['description'] = h['description'][0] if h['description']
          doc['body'] = h['body'][0] if h['body']
        end
      end
    end
    response
  end

  # Paginates a received Solr query.
  def paginate_solr_response collection, page = 1, per_page = ApplicationController::SOLR_RESULTS_PER_PAGE
    WillPaginate::Collection.create(page || 1, per_page) do |pager|
      pager.total_entries = [collection['response']['numFound'], ApplicationController::SOLR_MAX_RESULTS].min
      pager.replace(collection['response']['docs'][0, pager.per_page].to_a)
    end
  end

  def default_query_options params = {}
    params[:hl] = true
    params['hl.fragsize'] = 0
    params[:rows] = ApplicationController::SOLR_MAX_RESULTS
    params['hl.fl'] = ['title', 'description', 'body']
  end

end
