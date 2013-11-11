$:.unshift(File.expand_path('../../lib', __FILE__))

require 'sinatra/base'
require 'sinatra/partial'
require 'sinatra/flash'
require 'slim'
require 'sass'
require 'coffee-script'
require 'v8'
require 'asset_handler'
require 'rsolr'
require 'will_paginate'
require 'will_paginate/collection'

class ApplicationController < Sinatra::Base

  # Global constants.
  SOLR_SERVER = 'http://localhost:8080/solr'
  SOLR_MAX_RESULTS = 200
  SOLR_RESULTS_PER_PAGE = 10

  helpers ApplicationHelpers

  register Sinatra::Flash
  register Sinatra::Partial
  register WillPaginate::Sinatra

  configure do
    set :views, File.expand_path('../../views', __FILE__)
    set :partial_template_engine, :slim
    enable :partial_underscores
    enable :sessions, :method_override
  end

  use AssetHandler

  not_found{ slim :not_found }

end
