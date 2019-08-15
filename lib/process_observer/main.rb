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
        Linux.call.select { |process| process.status.include?("R") }
      else
        raise UnsupportedPlatformError, "This platform is currently unsupported", caller
    end
  end

  ##
  # Requests info about current Ruby process.
  #
  # @return [Process]
  def self.this
    pid = ::Process.pid
    case
      when OS.windows?
        arr = Windows.call(fi: "PID eq #{pid}")
      when OS.linux?
        arr = Linux.call.select { |process| process.pid == pid }
      else
        raise UnsupportedPlatformError, "This platform is currently unsupported", caller
    end
    raise MultipleProcessError, "Expected single process, got: #{arr.size}", caller if arr.size != 1
    arr[0]
  end

  ##
  # @return [Integer] used memory in KB.
  def self.used_memory
    self.all.sum(0, &:memory)
  end

end
