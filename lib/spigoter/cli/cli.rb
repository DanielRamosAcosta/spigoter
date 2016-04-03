module Spigoter
    module CLI
        def self.run(command, opts={})
            Run.new.task[command].call(opts)
        end

        class Run
            attr_reader :task
            def initialize
                @task = {
                    'update' => Spigoter::CLI.update,
                    'compile' => Spigoter::CLI.compile,
                    'start' => Spigoter::CLI.start,
                    'init' => Spigoter::CLI.init
                }
            end
        end
    end
end
