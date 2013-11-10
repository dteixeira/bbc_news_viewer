class WebsiteController < ApplicationController

  get '/' do
    define_topics
    @title = ''
    solr = RSolr.connect :url => 'http://localhost:8080/solr'
    @r = solr.get 'select', :params => { :q => '*:*', :rows => 99999 }
    puts @r['response']['numFound']
    @results = WillPaginate::Collection.create(params[:page] || 1, 10) do |pager|
      pager.total_entries = @r['response']['numFound']
      pager.replace(@r['response']['docs'][pager.offset, pager.per_page].to_a)
    end
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
