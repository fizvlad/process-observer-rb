module ProcessObserver

  ##
  # List of all active processes.
  #
  # @return [Array<Process>]
  def self.all
    case
      when OS.windows?
        # TODO
      when OS.unix?
        # TODO
      else
        raise UnsupportedPlatformError, "This platform is currently unsupported", caller
    end
  end

  ##
  # List of all running processes.
  #
  # @return [Array<Process>]
  def self.running
    case
      when OS.windows?
        # TODO
      when OS.unix?
        # TODO
      else
        raise UnsupportedPlatformError, "This platform is currently unsupported", caller
    end
  end

end
