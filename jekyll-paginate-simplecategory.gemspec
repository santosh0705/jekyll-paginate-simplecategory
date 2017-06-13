# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-paginate-simplecategory/version'

Gem::Specification.new do |s|
  s.name          = 'jekyll-paginate-simplecategory'
  s.version       = Jekyll::Paginate::Simplecategory::VERSION
  s.authors       = ['Santosh Kumar Gupta']
  s.email         = ['santosh0705@gmail.com']
  s.summary       = 'Simple Pagination Generator for Jekyll Posts Categories'
  s.description   = 'Automatically Generate Pagination for Jekyll Posts Categories'
  s.homepage      = 'https://github.com/santosh0705/jekyll-paginate-simplecategory'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.require_paths = ['lib']

  s.add_development_dependency 'jekyll', '~> 2.0', '>=2.0'
  s.add_development_dependency 'jekyll-paginate', '~> 1.1'
  s.add_development_dependency 'rake', '~> 0'
end
