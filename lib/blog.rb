require 'sinatra/base'
require 'github_hook'
require 'ostruct'
require 'time'

class Blog < Sinatra::Base
    use GithubHook
    #File.expand_path generates an absolute path.
    #It also takes a path as second argument.
    #The generated path is treated as being relative to that path.
    set :root, File.expand_path('../../../', __FILE__)
    set :articles, []
    set :app_file, __FILE__

    #loop through all articel files
    Dir.glob "#{root}/articles/*.md" do |file|
        
        #parse meta data and content from file
        meta, content = File.read(file).split("\n\n", 2)

        #generate a meta object
        article = OpenStruct.new YAML.load(meta)

        #convert the date to a time object
        article.date = Time.parse article.date.to_s

        #add content
        article.content = content

        #generate a slug from the url
        article.slug = File.basename(file, '.md')

        #set up the route
        get "/#{article.slug}" do 
            erb :post, :locals => { :article => article}
        end

        #Add article to the list of articles
        articles << article
    end

    #Sort articles by date and time, display newest article on top
    articles.sort_by! { |article| article.date }
    articles.reverse!

    get '/' do 
        erb :index
    end
end