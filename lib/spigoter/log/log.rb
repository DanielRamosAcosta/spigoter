require 'logging'

Logging.color_scheme('bright',
                     levels: {
                       info: :green,
                       warn: :yellow,
                       error: :red,
                       fatal: [:white, :on_red]
                     },
                     date: :blue,
                     logger: :cyan,
                     message: :magenta
)

Logging.appenders.stdout('stdout',
                         layout: Logging.layouts.pattern(pattern: '[%l] %c: %m\n',
                                                         color_scheme: 'bright'
                         )
)

# Module for logging all things, info warnings and errors.
# @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
module Log
  @log = Logging.logger['Spigoter']
  @log.add_appenders 'stdout'
  @log.level = :info

  def self.info(msg)
    @log.info msg
  end

  def self.warn(msg)
    @log.warn msg
  end

  def self.error(msg)
    @log.error msg
  end
end
