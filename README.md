# Spigoter

[![Build Status](https://travis-ci.org/DanielRamosAcosta/spigoter.svg?branch=master)](https://travis-ci.org/DanielRamosAcosta/spigoter)

Spigoter is a Ruby gem that gives you many tools make your server keepup easier.

## Installation

```ruby
gem install spigoter
```

## Usage

### Run the server
    spigoter

### Update plugins
    spigoter {-u|--update} {all|plugin1,plugin2,...}

### Compile spigot and set that version
    spigoter {-c|--compile} [lastest|1.9|1.8|...]

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DanielRamosAcosta/spigoter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

