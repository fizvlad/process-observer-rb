module ProcessObserver

  ##
  # Module with methods to identify current platform.
  #
  # Source: https://stackoverflow.com/a/171011/9293044
  module OS

    ##
    # Whether Windows is used.
    def OS.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    ##
    # Whether Mac is used.
    def OS.mac?
     (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    ##
    # Whether Unix (not Windows) is used.
    def OS.unix?
      !OS.windows?
    end

    ##
    # Whether Linux (Unix but not Mac) is used.
    def OS.linux?
      OS.unix? and not OS.mac?
    end
  end

end
