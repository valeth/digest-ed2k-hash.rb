# ED2K digest for Ruby

This is a Ruby implementation of the [ED2k](https://en.wikipedia.org/wiki/Ed2k_URI_scheme#eD2k_hash_algorithm) hashing algorithm.
Additional information can be found [here](http://wiki.anidb.net/w/Ed2k-hash).


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

puts Digest::ED2K.new('myfile').hexdigest
```


## Contributing

Bug reports and merge requests are welcome on [GitLab](https://gitlab.com/valeth/digest-ed2k-hash.rb).
