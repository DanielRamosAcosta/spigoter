# Spigoter

[![Gem Version](https://img.shields.io/gem/v/spigoter.svg?style=flat-square)](https://rubygems.org/gems/spigoter)
[![Gem Downloads](https://img.shields.io/gem/dt/spigoter.svg?style=flat-square)](https://rubygems.org/gems/spigoter)
[![Linux Build Status](https://img.shields.io/travis/DanielRamosAcosta/spigoter.svg?style=flat-square)](https://travis-ci.org/DanielRamosAcosta/spigoter)
[![Windows Build Status](https://img.shields.io/appveyor/ci/DanielRamosAcosta/spigoter.svg?style=flat-square)](https://ci.appveyor.com/project/DanielRamosAcosta/spigoter)
[![Coverage Status](https://img.shields.io/coveralls/DanielRamosAcosta/spigoter.svg?style=flat-square)](https://coveralls.io/github/DanielRamosAcosta/spigoter?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/DanielRamosAcosta/spigoter.svg?style=flat-square)](https://codeclimate.com/github/DanielRamosAcosta/spigoter)
[![Dependency Status](https://img.shields.io/gemnasium/DanielRamosAcosta/spigoter.svg?style=flat-square)](https://gemnasium.com/DanielRamosAcosta/spigoter)


Spigoter is a Ruby gem that gives you many tools in order to make your server keepup easier.

## Installation

```ruby
gem install spigoter
```

## Features

With this gem, you can easily mantain and update your plugins, recompile Spigot and start your server

## Quick Start

Install the gem, enter your server root directory and then:

    spigoter init

This will generate the necessary files that you need. Now customize your `spigoter.yml` and `plugins.yml` and you are ready to start!

* `spigoter update` updates your plugins
* `spigoter start` starts the server
* `spigoter compile` compiles spigot

For more info go to the [wiki](https://github.com/DanielRamosAcosta/spigoter/wiki)

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DanielRamosAcosta/spigoter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
