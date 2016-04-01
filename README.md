# Spigoter

[![Build Status](https://travis-ci.org/DanielRamosAcosta/spigoter.svg?branch=master)](https://travis-ci.org/DanielRamosAcosta/spigoter) [![Coverage Status](https://coveralls.io/repos/github/DanielRamosAcosta/spigoter/badge.svg?branch=master)](https://coveralls.io/github/DanielRamosAcosta/spigoter?branch=master) [![Dependency Status](https://gemnasium.com/DanielRamosAcosta/spigoter.svg)](https://gemnasium.com/DanielRamosAcosta/spigoter) [![Gem Version](https://badge.fury.io/rb/spigoter.svg)](https://badge.fury.io/rb/spigoter)


Spigoter is a Ruby gem that gives you many tools make your server keepup easier.

## Installation

```ruby
gem install spigoter
```

## Features

### Run the server
    spigoter [--javaparam="-Xms1024M -Xmx4096M ..."]

### Update plugins
    spigoter {-u|--update} {all|plugin1,plugin2,...}

### Usage
You have to drop a `plugin.json` file in the server root directory. There will be saved some relevant information of plugins, as well as some customization.

Example:

```json
[
  {
    "name": "Authme",
    "url": "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded",
    "type": "curse",
    "last_update": "31-3-2016 - 0:40"
  },
  {
    "name": "BossShop",
    "url": "http://mods.curse.com/bukkit-plugins/minecraft/bossshop",
    "type": "curse",
    "last_update": "31-3-2016 - 0:40"
  },
  {
    "name": "ChestShop",
    "url": "https://www.spigotmc.org/resources/1-9-chestshop.19511/",
    "type": "spigotmc",
    "last_update": "31-3-2016 - 0:40"
  },
  {
    "name": "ChopTree",
    "url": "https://www.spigotmc.org/resources/choptree.2046/",
    "type": "spigotmc",
    "last_update": "31-3-2016 - 0:40"
  },
  {
    "name": "ClickSort",
    "url": "http://mods.curse.com/bukkit-plugins/minecraft/clicksort",
    "type": "curse",
    "last_update": "31-3-2016 - 0:40"
  },
  {
    "name": "Dynmap",
    "url": "http://dev.bukkit.org/media/files/911/888/dynmap-2.3-alpha-1.jar",
    "type": "direct",
    "keep_eye_on": "http://dev.bukkit.org/bukkit-plugins/dynmap/files/",
    "last_update": "31-3-2016 - 0:40"
  }
]
```

I'm trying to switch to YAML.
#### Currently suported plugin hosted sites
* [Curse](http://mods.curse.com/bukkit-plugins/minecraft)
* [BukkitDev](http://dev.bukkit.org/)

#### Planned
* [Spigot](https://www.spigotmc.org/)
* Direct download
* Custom download via piping (first download, second unrar, then extract X file, ...)

### Compile Spigot and set version
    spigoter {-c|--compile} [lastest|1.9|1.8|...]

This command excecute the `buildtools .jar` in a `build`directory in the root server folder. Then, it'll replace the old version with the new one.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DanielRamosAcosta/spigoter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
