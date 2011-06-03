require "rubygems"
require "sinatra"
require "sinatra/static_assets"
require "mongo"
require "haml"

require "main"
require "bom"
run Sinatra::Application
