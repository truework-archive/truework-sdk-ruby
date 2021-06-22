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

The library needs to be configured with your verifier account's api key. Call `Truework.configure` with its value:

```ruby
require 'truework'

Truework.configure('myTrueworkToken')

# get the first 10 companies that match the query "International"

Truework::Company.list(q: 'International', limit: 10, offset: 0)
```

### Versioning
Pinning the client to a specific [version](https://www.truework.com/docs/api#versioning) of the Truework API is heavily recommended.
If not set, the latest version of the API will be used.

```ruby
Truework.configure('myTrueworkToken', api_version: '2019-10-15')
```

### Sandbox

The SDK can be configured to interact with the Truework Sandbox instead of the production environment for testing
purposes.

```ruby
Truework.configure('myTrueworkSandboxToken', environment: Truework::Environment::SANDBOX)
```

## Development

After checking out the repo and running `bin/setup`, tests can be run using the following command:

```bash
$ bundle exec rake spec
```

## Contributing

### Issues

If you run into problems, or simply have a question, feel free to [open an
issue](https://github.com/truework/truework-sdk-ruby/issues/new)!

### Commiting

This repo uses [commitizen](https://github.com/commitizen/cz-cli) to nicely
format commit messages. Upon making edits, stage your changes and simply run
`git commit` to enter the commitizen UI in your terminal.

**Note:** if you are not prompted with the commitizen UI, run `npm run prepare` to install the git hook.

### Releases

This project is versioned and published automatically using
[semantic-release](https://github.com/semantic-release/semantic-release) and
[semantic-release-rubygem](https://github.com/Gusto/semantic-release-rubygem). Via a
GitHub Action, `semantic-release` will use the commit message pattern provided
by `commitizen` to automatically version the package. It will then publish to
RubyGems, as well as create a new
[release](https://github.com/truework/truework-sdk-ruby/releases) here in the
main repo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
