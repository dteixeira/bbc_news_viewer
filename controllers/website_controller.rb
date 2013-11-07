class WebsiteController < ApplicationController

  get '/' do
    slim :home
  end

end
