$LOAD_PATH.unshift 'lib'

#this is option
# require 'rack/cache'
# use Rack::Cache

require 'blog'
Blog.run!