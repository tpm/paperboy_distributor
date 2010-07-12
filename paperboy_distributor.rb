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
  
  @e = StatsCombiner::Filterer.new
  @e.add :prefix => 'tpmdc', :title_regex => /\| TPMDC/, :modify_title => true
  @e.add :prefix => 'tpmmuckraker', :title_regex => /\| TPMMuckraker/, :modify_title => true
  @e.add :prefix => 'tpmtv', :title_regex => /\| TPMTV/, :modify_title => true
  @e.add :prefix => 'tpmcafe', :title_regex => /\| TPMCafe/, :modify_title => true
  @e.add :prefix => 'tpmlivewire', :title_regex => /\| TPM LiveWire/, :modify_title => true
  @e.add :prefix => 'tpmpolltracker', :title_regex => /\| TPM PollTracker/, :modify_title => true
  @e.add :prefix => 'www', :title_regex => /\|.*$/, :modify_title => true
  
  #kill query strings
  @e.add :path_regex => /((\?|&)ref=.*)/, :suffix => '', :modify_path => true
  
  #for page and img, send ppl back to page 1
  @e.add :path_regex => /(\?(page|img)=(.*)($|&))/, :suffix => '?\2=1'
  
  #put excluders last
  @e.add :path_regex => /(\/$|\/index.php$)/, :exclude => true
  @e.add :path_regex => /doubleclick/, :exclude => true

  
 y = Paperboy::Distributor.get_opts('opts.yml')

 p = Paperboy::Collector.new({
        :apikey => y['apikey'],
        :host => y['host'],
        :start_time => params[:start_time].to_i,
        :end_time => params[:end_time].to_i,
        :interval => 3600, #four hours
        :filters => @e.filters,
        :img_xpath => y['img_xpath'],
        :blurb_xpath => y['blurb_xpath']
 })
 
 
 p.run({
        :via => 'erb',
        :template => 'views/paperboy_tmpl.erb'
 })
 
 @html = p.html
  
 erb :result
end