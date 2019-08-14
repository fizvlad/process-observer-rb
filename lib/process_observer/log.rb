require "logger"

module ProcessObserver

  ##
  # Logging methods
  module Log

    ##
    # Loggers
    @@loggers = {
      debug: Logger.new(STDOUT),
      warn: Logger.new(STDERR)
    }
    @@loggers[:debug].level = Logger::DEBUG
    @@loggers[:warn].level = Logger::WARN

    ##
    # Send warning.
    def self.warn(*args)
      @@loggers[:warn].warn(args.join("\n"))
    end

    ##
    # Send debug message.
    def self.debug(*args)
      @@loggers[:debug].debug(args.join("\n")) if $DEBUG
    end

  end

end
