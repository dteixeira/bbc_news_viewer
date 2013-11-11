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
    params[:defType] = 'edismax'
    params[:hl] = true
    params['hl.fragsize'] = 0
    params[:rows] = ApplicationController::SOLR_MAX_RESULTS
    params['hl.fl'] = ['title', 'description', 'body']
    params[:qf] = "title^#{ApplicationController::TITLE_BOOST}"
    params[:qf] += " description^#{ApplicationController::DESCRIPTION_BOOST}"
    params[:qf] += " body^#{ApplicationController::BODY_BOOST}"
  end

  def advanced_query_options params = {}, p = {}, topics

    # Set options.
    params[:fq] = ''
    set_slop_parameter params, p
    set_fields_parameter params, p

    # Set restrictions.
    fq = []
    fq << set_topic_restrictions(p, topics)
    fq << set_media_restrictions(p)
    fq << set_date_restrictions(p)
    fq = fq - ['']
    params[:fq] = fq.join ' AND '
  end

  private
  def set_fields_parameter params, p
    a = []
    a << "title^#{ApplicationController::TITLE_BOOST}" if p['title'] != 'nil'
    a << "description^#{ApplicationController::DESCRIPTION_BOOST}" if p['description'] != nil
    a << "body^#{ApplicationController::BODY_BOOST}" if p['body'] != nil
    params[:qf] = a.join ' '
  end

  def set_slop_parameter params, p
    params['qs'] = p['slop'] || 0
  end

  def set_date_restrictions p
    begin_date = p['begin-date'] || ''
    begin_date = begin_date == '' ? '*' : "#{begin_date}T00:00:00Z/DAY"
    end_date = p['end-date'] || ''
    end_date = end_date == '' ? '*' : "#{end_date}T00:00:00Z/DAY+1DAY"
    return "date:[#{begin_date} TO #{end_date}]"
  end

  def set_media_restrictions p
    video = p['video'] || 'none'
    audio = p['audio'] || 'none'
    a = []
    a << "video:#{video}" if video != 'none'
    a << "audio:#{audio}" if audio != 'none'
    return ('(' + a.join(' AND ') + ')') if a.length > 0
    return ''
  end

  def set_topic_restrictions p, topics
    a = []
    topics.each do |k, v|
      key = "topic_#{k}"
      if p[key] != nil
        a << "topics:#{k}"
      else
        a << "NOT topics:#{k}"
      end
    end
    return ('(' + a.join(' OR ') + ')').gsub(/OR NOT/, 'NOT') if a.length > 0
    return ''
  end

end
