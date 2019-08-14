module ProcessObserver

  ##
  # List of all active processes.
  #
  # @return [Array<Process>]
  def self.all
    case
      when OS.windows?
        Windows.call
      when OS.linux?
        Linux.call
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
        Windows.call(fi: "STATUS eq RUNNING")
      when OS.linux?
        Linux.call.select { |process| process.include?("R") }
      else
        raise UnsupportedPlatformError, "This platform is currently unsupported", caller
    end
  end

end
