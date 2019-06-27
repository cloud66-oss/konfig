# Konfig

Konfig is a Kubernetes friendly Rails configuration file. While Rails applications can easily read YAML files to load configurations, Kubernetes is good at serving individual configuration values as files via Kubernetes Secrets. This means your Rails application needs to read the same configuration file from a YAML file in development or an individual file while running in Kubernetes. Konfig can load configuration and secrets from both YAML or folders with individual files and present them to your application the same way.

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

```ruby
Konfig.configuration.mode = :yaml
Konfig.configuration.workdir = "settings/folder"
Konfig.load
```

or if you'd like to use it in Kubernetes:

```ruby
Konfig.configuration.mode = :directory
Konfig.configuration.workdir = "settings/folder"
Konfig.load
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
# directory mode
$ ls config/settings
-rw-r--r--    1 khash  staff    20 10 May 07:20 some.configuration.value

$ cat config/settings/some.configuration.value
true
```

The value in `some.configuration.value` file can be `true`. Konfig tries to clean the file and coerce the value into the right type before returning. If the file or the key in yaml is missing, it will return a `Konfig::MissingConfiguration` is thrown.

### NULL / nil values

By default YAML returns `nil` for a `null` value in a YAML file. This is also replicated in directory mode.

### Configuration
You can change or reach the following from `Konfig.configuration`

`namespace`: Default is `Settings`
`delimiter`: Default is `.`
`default_config_file`: Default is `development.yml`
`allow_nil`: Default is `true`
`nil_word`: Default is `null`
`mode`: No default value
`workdir`: No default value

### Data types

The directory mode, supports the following data types in files and tries to return the right type:

- Integer
- Float
- String
- Date time
- Boolean
- Null (see above)

### ERB

YAML mode supports ERB in your YAML file, just like default Rails behavior

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khash/konfig.
