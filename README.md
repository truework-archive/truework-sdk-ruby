# Truework Ruby SDK

A first party software development kit (SDK) for the [Truework API](https://www.truework.com/docs/api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'truework'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install truework

## Requirements

- Ruby 2.4+

## Usage

The library needs to be configured with your verifier account's api key. Set `Truework.api_key` to its
value:

```ruby
require 'truework'

Truework.api_key = 'myTrueworkToken'

# get the first 10 companies that match the query "International"

Truework::Company.list(q: 'International', limit: 10, offset: 0)
```

### Versioning
Pinning the client to a specific [version](https://www.truework.com/docs/api#versioning) of the Truework API is heavily recommended.
If not set, the latest version of the API will be used.

```ruby
Truework.api_version = '2019-10-15'
```

### Configuring CA Bundles

By default, the library will use its own internal bundle of known CA
certificates, but it's possible to configure your own:

```ruby
Truework.ca_bundle_path = 'path/to/ca/bundle'
```

## Development

After checking out the repo and running `bin/setup`, tests can be run using the following command:

```bash
$ bundle exec rake spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/truework/truework-sdk-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
