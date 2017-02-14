# ED2K digest for Ruby

[![build status](https://gitlab.com/valeth/digest-ed2k-hash.rb/badges/master/build.svg)](https://gitlab.com/valeth/digest-ed2k-hash.rb/commits/master)
[![Build Status](https://travis-ci.org/valeth/digest-ed2k-hash.rb.svg?branch=master)](https://travis-ci.org/valeth/digest-ed2k-hash.rb)
[![Gem](https://img.shields.io/gem/v/digest-ed2k-hash.svg)](https://rubygems.org/gems/digest-ed2k-hash)
[![Gem](https://img.shields.io/gem/dt/digest-ed2k-hash.svg)](https://rubygems.org/gems/digest-ed2k-hash)
[![Inline docs](https://inch-ci.org/github/valeth/digest-ed2k-hash.rb.svg?branch=master&style=shields)](https://inch-ci.org/github/valeth/digest-ed2k-hash.rb)
[![Code Climate](https://codeclimate.com/github/valeth/digest-ed2k-hash.rb/badges/gpa.svg)](https://codeclimate.com/github/valeth/digest-ed2k-hash.rb)
[![Test Coverage](https://codeclimate.com/github/valeth/digest-ed2k-hash.rb/badges/coverage.svg)](https://codeclimate.com/github/valeth/digest-ed2k-hash.rb/coverage)

This is a Ruby implementation of the [ED2k](https://en.wikipedia.org/wiki/Ed2k_URI_scheme#eD2k_hash_algorithm) hashing algorithm.
Additional information can be found [here](http://wiki.anidb.net/w/Ed2k-hash).

[Documentation](http://www.rubydoc.info/gems/digest-ed2k-hash)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'digest-ed2k-hash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install digest-ed2k-hash


## Example usage

```ruby
require 'digest/ed2k'

# Create a hexdigest of a file
puts Digest::ED2K.file('myfile').hexdigest

# Append strings to a digest object
dig = Digest::ED2K.new
dig << 'hello'
dig << ' world'
dig.finish
puts dig.hexdigest
```


## Contributing

Bug reports and merge requests are welcome on [GitLab](https://gitlab.com/valeth/digest-ed2k-hash.rb).
