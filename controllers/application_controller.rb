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

class ApplicationController < Sinatra::Base

  helpers ApplicationHelpers

  register Sinatra::Flash
  register Sinatra::Partial

  configure do
    set :views, File.expand_path('../../views', __FILE__)
    set :partial_template_engine, :slim
    enable :partial_underscores
    enable :sessions, :method_override
  end

  use AssetHandler

  not_found{ slim :not_found }

end
