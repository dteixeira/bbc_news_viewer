class WebsiteController < ApplicationController

  get '/' do
    define_topics
    @title = ''
    solr = RSolr.connect :url => 'http://localhost:8080/solr'
    response = solr.get 'select', :params => {:q => '*:*', :rows => 5}
    @results = response['response']['docs']
    slim :home
  end

  private
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

end
