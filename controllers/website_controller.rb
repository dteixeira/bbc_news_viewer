class WebsiteController < ApplicationController

  get '/' do
    @title = ''
    slim :home
  end

end
