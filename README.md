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

### Run the server
    spigoter start

### Update plugins
    spigoter update [--list=plugin1,plugin2,...]

#### Usage
You have to drop a `plugin.yml` file in the server root directory. There will be saved some relevant information of plugins, as well as some customization.

Basic example:

```yml
Authme:
  type: curse
  url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
ChopTree:
  type: spigotmc
  url: "https://www.spigotmc.org/resources/choptree.2046/"
Dynmap:
  type: devbukkit
  url: "http://dev.bukkit.org/bukkit-plugins/dynmap/"
Essentials:
  type: direct
  url: "https://hub.spigotmc.org/jenkins/job/Spigot-Essentials/lastSuccessfulBuild/artifact/Essentials/target/Essentials-2.x-SNAPSHOT.jar"
  keep_eye_on: "https://hub.spigotmc.org/jenkins/job/Spigot-Essentials/"
EssentialsChat:
  type: direct
  url: "https://hub.spigotmc.org/jenkins/job/Spigot-Essentials/lastSuccessfulBuild/artifact/EssentialsChat/target/EssentialsChat-2.x-SNAPSHOT.jar"
Multiverse-core:
  keep_eye_on: "http://mods.curse.com/bukkit-plugins/minecraft/multiverse-core"
  type: direct
  url: "http://ci.onarandombox.com/job/Multiverse-Core/lastSuccessfulBuild/artifact/target/Multiverse-Core-2.5.jar"
Towny:
  type: manual
  url: "http://palmergames.com"
```

#### Currently suported plugin hosted sites
* [Curse](http://mods.curse.com/bukkit-plugins/minecraft)
* [BukkitDev](http://dev.bukkit.org/)

#### Planned
* [Spigot](https://www.spigotmc.org/)
* Direct download
* Manual
* Custom download via piping (first download, second unrar, then extract X file, ...)

### Update Spigot's version
    spigoter compile [--version={1.9|1.8|...}]

This command excecute the `buildtools .jar` in a `build`directory in the root server folder. Then, it'll replace the old version with the new one.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DanielRamosAcosta/spigoter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
