require 'sinatra'
require 'sinatra/reloader'
require "sinatra/json"
require 'rack-flash'
require 'sinatra/redirect_with_flash'

require 'pry-byebug'
require 'pry-alias'

require './webpage'
require './typeform_request'
require './typeform_callback'
require './google_form_request'

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash
  helpers Sinatra::RedirectWithFlash

  configure :development do
    register Sinatra::Reloader
    also_reload "./*.rb"
  end

  get '/' do
    erb :root
  end

  post '/generate_form' do
    @google_form_url = params[:google_form_url]
    begin
      page = Webpage.new(@google_form_url)
      if page.json_fields.any?
        request = TypeformRequest.new(fields: page.json_fields, title: page.title, form_submit_url: page.form_submit_url)

        response = request.send
      else
        redirect "/", error: "Provided google form is empty."
        return
      end
    rescue UnsupportedFieldType
      redirect "/", error: "Provided google form contains unsupported field type."
      return
    end

    @title = page.title
    @typeform_url = response["_links"].find { |i| i['rel'] == 'form_render' }["href"]

    erb :form_created
  end

  post "/form_submit" do
    callback = TypeformCallback.new(request.body.read)
    form_submit_url = params[:form_submit_url]

    GoogleFormRequest.new(answers: callback.answers, url: form_submit_url).perform!
  end
end
