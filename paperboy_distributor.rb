$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'sinatra'
require 'paperboy'
require 'paperboy_distributor/base'

get '/' do
 @page_title = "Paperboy"
  
 erb :index
end

get '/from/:start_time/to/:end_time' do
 @page_title = "Fresh Hot News"
 
 # to use filters, uncomment 
 # these lines, add filters as needed,
 # and uncommend `e.filters` in `Paperboy::Collector.new` below
 # @e = StatsCombiner::Filterer.new
 # @e.add :prefix => 'tpmdc', :title_regex => /\| TPMDC/, :modify_title => true

 # Get chartbeat credentials and other options
 # from YML file
 y = Paperboy::Distributor.get_opts('opts.yml')
 
 # create a Paperboy instance, and pass query params
 # for start and end times to it.
 p = Paperboy::Collector.new({
        :apikey => y['apikey'],
        :host => y['host'],
        :start_time => params[:start_time].to_i,
        :end_time => params[:end_time].to_i,
        :interval => 3600, #four hours
 #      :filters => @e.filters,
        :img_xpath => y['img_xpath'],
        :blurb_xpath => y['blurb_xpath']
 })
 
 # Run with specified template
 p.run({
        :via => 'erb',
        :template => 'views/paperboy_tmpl.erb'
 })
 
 # Grab the html and pass it to the result view
 @html = p.html
  
 erb :result
end