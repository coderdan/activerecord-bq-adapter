# Activerecord::Bq::Adapter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-bq-adapter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-bq-adapter

## Usage

TODO: Write usage instructions here

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
