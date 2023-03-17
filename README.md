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

## See also

- [Terraforming Rails](https://github.com/evilmartians/terraforming-rails)

## License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[the-post]: https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development
[Ruby Bytes]: https://github.com/palkan/rbytes
