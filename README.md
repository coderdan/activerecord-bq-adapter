# Activerecord::Bq::Adapter

Basic Implementation of an ActiveRecord Adapter for Google's Big Query. Just handles queries right now. See TODO list in the Readme for whats coming.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-bq-adapter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-bq-adapter

## Usage

Set your model to use the adapter. You probably won't want to do it for your entire app but rather just specific models like:

    class MyModel < ActiveRecord::Base
      set_table_name "<bq_dataset>.<bq_table>"
      establish_connection(
        :adapter    => "bq",
        :project_id => <project_id>,
        :client_id  => "<project_id>.apps.googleusercontent.com",
        :client_secret => <client-secret>,
        :refresh_token => <token>
      )
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Asynchronous Queries, Inserts, Job handling
* Insert
* Bulk Inserts (from file, URL)
* Append vs Rewrite on insertion
* Specify table for results output
* Handle select * type queries (BigQuery requires explicit column names in select) - possibly use the Browsing Data part of the API
* Caching - perhaps using Faraday Middleware
