<img src="http://cdn2-cloud66-com.s3.amazonaws.com/images/oss-sponsorship.png" width=150/>

[![Codeship Status for cloud66-oss/konfig](https://app.codeship.com/projects/a8c71410-8ca4-0137-dc36-6a27a0c61ea4/status?branch=master)](https://app.codeship.com/projects/355428)

# Konfig

Konfig is a Kubernetes friendly Rails configuration file. While Rails applications can easily read YAML files to load configurations, Kubernetes is good at serving individual configuration values as files via Kubernetes Secrets. This means your Rails application needs to read the same configuration file from a YAML file in development or an individual file while running in Kubernetes. Konfig can load configuration and secrets from both YAML or folders with individual files and present them to your application the same way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rb-konfig'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rb-konfig

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

In `file` mode, Konfig, looks for any of the files specified in `default_config_files`. By default and in a non-Rails environment this will be `development.yml` and `development.local.yml` files in `work_dir`. In a Rails environment, this will be `ENVIRONMENT.yml` and `ENVIRONMENT.local.yml` files (ie `production.yml` and `production.local.yml`) files. Files added to the list later will override the values in the earlier defined files. This means, `production.local.yml` values will override `production.yml` values.
In `kubernetes` mode, it looks for a file for each one of the given configuration keys. For example:

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

### Environment Variable Overrides

Settings can be overridden by values in environment variables. To override a value, set an environment variable that reflects the full path to the setting, replacing `.` with `_` and prefixing it with `KONFIG_`. You can change the prefix using `Konfig.configuration.env_prefix`. For example, `Settings.this.is.a.test` can be overridden with `KONFIG_THIS_IS_A_TEST`. Environment variables are not parsed for Ruby (ERB) but are coerced into the right type just like other settings.

### Configuration
You can change or reach the following from `Konfig.configuration`

* `namespace`: Default is `Settings`
* `delimiter`: Default is `.`
* `default_config_files`: Default is [`development.yml`, `development.local.yml`]
* `allow_nil`: Default is `true`
* `nil_word`: Default is `null`
* `mode`: No default value
* `workdir`: No default value
* `schema`: Configuration validation schema. If available, the loaded, merged and parsed configuration is validated against this schema. See [Dry-Schema](https://dry-rb.org/gems/dry-schema/) for more information.
* `fail_on_validation`: Fail if schema validation fails

### Data types

The directory mode, supports the following data types in files and tries to return the right type:

- Integer
- Float
- String
- Boolean
- JSON
- Null (see above)

### ERB

YAML mode supports ERB in your YAML file, just like default Rails behavior

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## CLI

Konfig has a CLI to generate validation schema based on a given yaml file. To generate, run:

```bash
$ konfig gs --in sample.yml
```

This will generate the ruby code that can be used for `Konfig.configuration.schema` like the one below:

```ruby
Konfig.configuration.schema do
  required(:some).schema do
    required(:setting).filled(:string)
    required(:another).filled(:integer)
    required(:and_more).filled(:bool)
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cloud66-oss/konfig.
