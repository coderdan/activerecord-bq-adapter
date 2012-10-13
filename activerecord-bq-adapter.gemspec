# -*- encoding: utf-8 -*-
require File.expand_path('../lib/activerecord-bq-adapter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Draper"]
  gem.email         = ["daniel@codefire.com"]
  gem.description   = %q{Basic Implementation of an ActiveRecord Adapter for Google's Big Query. Just handles queries right now. See TODO list in the Readme for whats coming.}
  gem.summary       = %q{Basic Implementation of an ActiveRecord Adapter for Google's Big Query}
  gem.homepage      = ""

  gem.add_dependency "multipart_body", "~> 0.2.1"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "activerecord-bq-adapter"
  gem.require_paths = ["lib"]
  gem.version       = Activerecord::Bq::Adapter::VERSION
end
