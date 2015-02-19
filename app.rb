lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra'
require 'action_dispatch/http/mime_type' # just to make kaminari work
require 'r_project'
 
class App < Sinatra::Base

  register Kaminari::Helpers::SinatraHelpers

  get '/' do
    @packages = RProject::Package.includes(:versions).page(params[:page]).per(100)
    haml :index, layout: 'layout'
  end

  get '/person/:id' do
    @person = RProject::Person.find(params[:id])
    haml :person, layout: 'layout'
  end

  get '/package/:id' do
    @person = RProject::Person.find(params[:id])
    haml :package, layout: 'layout'
  end

  get '/package/:package_id/versions/:id' do
    @package = RProject::Package.find(params[:package_id])
    @version = @package.versions.find(params[:id])
    haml :version, layout: 'layout'
  end

  get '/search' do
    @packages = RProject::Package.includes(:versions).where(name: %r{#{params[:term]}}).page(params[:page]).per(100)
    haml :index, layout: 'layout'
  end

end
