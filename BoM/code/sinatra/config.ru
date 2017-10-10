require "rubygems"
require "sinatra"
require "sinatra/static_assets"
require "mongo"
require "haml"

require "./main.rb"
require "./bom.rb"
run Sinatra::Application
