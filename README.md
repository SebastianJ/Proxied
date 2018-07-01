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

If you're using ActiveRecord, generate the migration and model:

    $ rails generate proxied MODEL

If you're using Mongoid, generate the model using the following command:

    $ rails generate proxied MODEL --orm=mongoid

## Features

Features:

* ActiveRecord model and migration or Mongoid model for managing your proxy data.

* Common model methods for selecting random proxies (based on protocol, etc.) for both ActiveRecord and Mongoid.

* A proxy checker to check the status for HTTP(S) and Socks proxies (with configurable test setups).

* An importer that will bulk import proxies for you.

* Sidekiq jobs to asynchronously check proxies.

## Usage

1. Set up the gem according to the installation instructions.
2. Import proxies.
3. Schedule the rake task (proxied:check_proxies) using cron or schedule the Sidekiq job (Proxied::Jobs::CheckProxiesJob) using a scheduler for Sidekiq.
4. Use the model methods to query for valid proxies (the maximum failed attempts etc. are configurable using the global Proxied.configure-method).
5. Use the proxies/proxy from the resulting query to perform HTTP(S) or SOCKS requests using the proxy. Some helper methods, e.g. #proxy_options_for_faraday are included to help with integration with some common gems.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To test specific appraisals/gemfiles, you can do

* ActiveRecord: bundle exec appraisal activerecord5 rake spec

In order to test specific specs: bundle exec appraisal activerecord5 rspec spec/lib/generators/activerecord_generator_spec.rb

* Mongoid: bundle exec appraisal mongoid7 rake spec ADAPTER=mongoid

In order to test specific specs: ADAPTER=mongoid bundle exec appraisal mongoid7 rspec spec/lib/generators/mongoid_generator_spec.rb


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SebastianJ/proxied. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Proxied project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/SebastianJ/proxied/blob/master/CODE_OF_CONDUCT.md).
