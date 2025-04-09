# Ruby on Whales

This repository contains an example dockerized Ruby on Rails development configuration based on the [Ruby on Whales blog post][the-post].

<p align="center">
  <img width="360" height="300"
       title="Ruby on Whales logo" src="./assets/logo.png">
</p>

## Example configuration

See the [example](./example) folder.

## Interactive generator

We also provide an interactive generator for Rails apps to quickly setup a dockerized environment for your app. Just run the following command and follow the instructions:

```sh
bundle exec rails app:template LOCATION='https://railsbytes.com/script/z5OsoB'
```

You can also run it via [Ruby Bytes][] (so you can dockerize a Rails app without installing it on your host machine):

```sh
rbytes install https://railsbytes.com/script/z5OsoB
```

## Tips & Tricks

### Pry / IRB history support

To persiste Pry or IRB history, you must configure them to store it in the `history` volume.

For IRB, add the following to your `.irbrc` file:

```ruby
IRB.conf[:SAVE_HISTORY] = 10_000 # Maximum number of lines to save in history
IRB.conf[:HISTORY_FILE] = ENV.fetch("IRB_HISTFILE", "#{ENV["HOME"]}/.irb-history")
```

Then, in the `compose.yml`, specify the `IRB_HISTFILE` environment variable:

```yaml
x-backend:
  environment:
    # ...
    IRB_HISTFILE: /usr/local/hist/.irb_history
```

Similarly, for Pry, add the following to your `.pryrc` file:

```ruby
Pry.config.history_save = true
Pry.config.history_file = ENV.fetch("PRY_HISTFILE", "#{ENV["HOME"]}/.pry-history")
```

Then, in the `compose.yml`, specify the `PRY_HISTFILE` environment variable:

```yaml
x-backend:
  environment:
    # ...
    PRY_HISTFILE: /usr/local/hist/.pry_history
```

## See also

- [System of a test](https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing#dockerizing-system-tests) (setting up system tests with Docker)
- [Vite-alizing Rails](https://evilmartians.com/chronicles/vite-lizing-rails-get-live-reload-and-hot-replacement-with-vite-ruby#dockerizing-vite-or-not) (more about using Vite with Rails and Docker)
- [Faster RuboCop runs for Rails](https://dev.to/palkan_tula/faster-rubocop-runs-for-rails-apps-10me)
- [Terraforming Rails](https://github.com/evilmartians/terraforming-rails)

## License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[the-post]: https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development
[Ruby Bytes]: https://github.com/palkan/rbytes
