# paperboy_distributor

A sample sinatra app based on the [paperboy gem](http://github.com/tpm/paperboy) for generating HTML newsletters from popular stories. 

## How?

Paperboy aggregates stories from chartbeat's `snapshots` endpoint over a given time period and scrapes the URLs for META tags containing images and blurbs to create ready-made or templateable emails. 

Paperboy_distributor is a frontend for Paperboy. It uses JavaScript to generate a range of time period options over the past several days to pull stories from. It then provides a preview, and a textarea of code for editors to use to produce a daily email. This is essentially the app we now use at TPM for our [DayBreaker  emails](http://dl.dropbox.com/u/715596/Picture%20799.png). 

## Install and use

Make sure you have Sinatra (`sudo gem install sinatra`) and Paperboy (`sudo gem install paperboy`)

`git clone git://github.com/tpm/paperboy_distributor`
`cd paperboy_distributor`
Rename `opts.yml.sample` to `opts.yml`, fill in your chartbeat credentials and xpath prefs (for slurping up images and descriptions from META tags)

open `paperboy_distributor.rb` and fill in custom [filters](http://github.com/tpm/stats\_combiner/blob/master/README.md).

The `views/paperboy_tmpl.erb` file is the template file Paperboy will run stories through. It's currently set up with our DayBreaker template. The template loops through a `@stories` array. Each item in the array has the components: 

    item[:url]
    item[:hed]
    item[:img]
    item[:blurb]

See a sample bare-bones structure [here](http://tpm.github.com/paperboy/#section-20).

Run app with `ruby paperboy_distributor.rb`
Open browser to http://localhost:4567

## License

Copyright (c) 2010 TPM Media LLC

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
