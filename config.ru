require 'rack'
require 'rack/contrib/try_static'
require 'rack-zippy'
require 'zippy_static_cache'
# Heroku New Relic Addon
require 'newrelic_rpm' if ENV['RACK_ENV'] == 'production'

use ZippyStaticCache, :urls => ['/images', '/stylesheets', '/javascripts', '/fonts']
use Rack::Zippy::AssetServer, 'build'
use Rack::TryStatic,
  root: 'build',
  urls: %w[/],
  try: ['.html', 'index.html', '/index.html']

# otherwise 404
run lambda{ |env|
  four_oh_four_page = File.expand_path("../build/404/index.html", __FILE__)
  [ 404, { 'Content-Type'  => 'text/html'}, [ File.read(four_oh_four_page) ]]
}

# Build when app boots
`bundle exec middleman build`
