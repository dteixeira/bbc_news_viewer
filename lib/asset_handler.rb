class AssetHandler < Sinatra::Base

  configure do
    set :root, File.expand_path('../../',__FILE__)
    set :views, settings.root + '/assets'
    enable :coffeescript
    set :jsdir, 'javascripts'
    set :cssdir, 'stylesheets'
    set :cssengine, 'scss'
  end

  get '/coffescripts/*.js' do
    pass unless settings.coffeescript?
    last_modified File.mtime(settings.root + '/assets/' + settings.jsdir)
    cache_control :public, :must_revalidate
    coffee (settings.jsdir + '/' + params[:splat].first).to_sym
  end

  get '/javascripts/*.js' do
    send_file(settings.views + '/' + settings.jsdir + '/' + params[:splat].first + '.js')
  end

  get '/stylesheets/*.css' do
    last_modified File.mtime(settings.root + '/assets/' + settings.cssdir)
    cache_control :public, :must_revalidate
    send(settings.cssengine, (settings.cssdir + '/' + params[:splat].first).to_sym)
  end

end
