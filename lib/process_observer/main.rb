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
  # @param process_list [Array<Process>, nil] previously saved array of processes 
  #   or +nil+ if you want to request all processes in this method.
  #
  # @return [Process, nil] +nil+ may be returned if process not found in provided process list.
  def self.this(process_list = nil)
    pid = ::Process.pid

    if process_list
      return process_list.find { |process| process.pid == pid }
    end

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
  # Get total used memory.
  #
  # @param process_list [Array<Process>, nil] previously saved array of processes 
  #   or +nil+ if you want to request all processes in this method.
  #
  # @return [Integer] used memory in KB.
  def self.used_memory(process_list = nil)
    arr = process_list ? process_list : self.all
    arr.sum(0, &:memory)
  end

end
