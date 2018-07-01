# Proxied

Proxied is a proxy management gem.

Supports ActiveRecord and Mongoid as database adapters.

Includes a proxy checker for both HTTP/HTTPS and SOCKS.

Includes Sidekiq jobs for invoking the checker asynchronously and/or in a scheduled fashion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proxied'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proxied

Generate the initializer for your Rails app:

    $ rails generate proxied:install MODEL

Generate the migration and model:

    $ rails generate proxied MODEL


## Usage

- TODO -

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To test specific appraisals/gemfiles, you can do

* ActiveRecord: bundle exec appraisal activerecord5 rake spec

In order to test specific specs: bundle exec appraisal activerecord5 rspec spec/lib/generators/activerecord_generator_spec.rb

* Mongoid: bundle exec appraisal mongoid7 rake spec ADAPTER=mongoid

In order to test specific specs: ADAPTER=mongoid bundle exec appraisal mongoid7 rspec spec/lib/generators/mongoid_generator_spec.rb


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/proxied. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Proxied project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/proxied/blob/master/CODE_OF_CONDUCT.md).
