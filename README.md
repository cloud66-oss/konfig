# Konfig

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/konfig`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'konfig'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install konfig

## Usage

First, configure Konfig itself:

```ruby
Konfig.mode = Rails.env.development? ? :development : :kuberentes
Konfig.work_dir = File.join(Rails.root, 'config', 'settings')
```

Now you can use Konfig anywhere in the code:

```ruby
puts Settings.some.configuration.value
```

In `development` mode, Konfig, looks for `development.yml` in `work_dir`. In `kubernetes` mode, it looks for a file for each one of the given configuration keys. For example:

```yml
# development.yml
some:
    configuration:
        value: true
```

```bash
# kubernetes mode
$ ls config/settings

-rw-r--r--    1 khash  staff    20 10 May 07:20 some.configuration.value
```

The value in `some.configuration.value` file can be `true`. Konfig tries to clean the file and coerce the value into the right type before returning. If the file or the key in yaml is missing, it will return a `Konfig::MissingConfiguration` is thrown.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/konfig.
