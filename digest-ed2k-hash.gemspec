# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'digest/ed2k/version'

Gem::Specification.new do |spec|
    spec.name          = 'digest-ed2k-hash'
    spec.version       = Digest::ED2K::VERSION
    spec.authors       = ['Valeth']
    spec.email         = ['']

    spec.summary       = ''
    spec.homepage      = 'https://gitlab.com/valeth/digest-ed2k-hash.rb'

    spec.files         = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ['lib']

    spec.add_development_dependency 'bundler', '~> 1.14'
    spec.add_development_dependency 'rake',    '~> 10.0'
    spec.add_development_dependency 'rspec',   '~> 3.0'
    spec.add_development_dependency 'yard'
end
