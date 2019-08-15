module ProcessObserver

  ##
  # Class representing process.
  class Process

    ##
    # @return [String] name name of the executable or command.
    attr_reader :name

    ##
    # @return [Integer] pid process ID.
    attr_reader :pid

    ##
    # @return [Integer, nil] memory amount of consumed memory.
    attr_reader :memory

    ##
    # Initialize new process.
    #
    # @param options [Hash]
    #
    # @option options [String] name name of the executable or command.
    # @option options [Integer] pid process ID.
    # @option options [Integer, nil] memory amount of consumed memory.
    def initialize(options)
      @name   = options[:image_name].to_s
      @pid    = options[:pid].to_i
      @memory = options[:memory] ? options[:memory].to_i : nil
    end

  end

  ##
  # Class representing process in Windows.
  class WindowsProcess < Process

    ##
    # @return [String] name of the executable.
    attr_reader :image_name

    ##
    # @return [Integer] process ID.
    attr_reader :pid

    ##
    # @return [String, nil] session name.
    attr_reader :session_name

    ##
    # @return [Integer, nil] session number.
    attr_reader :session

    ##
    # @return [Integer, nil] memory usage in KB.
    attr_reader :mem_usage

    ##
    # @return [String, nil] process status.
    attr_reader :status

    ##
    # @return [String, nil] user which started process.
    attr_reader :user_name

    ##
    # @return [String, nil] process runtime.
    attr_reader :cpu_time

    ##
    # @return [String, nil] title of process window.
    attr_reader :window_title

    ##
    # @return [Array<String>] services.
    attr_reader :services

    ##
    # @return [Array<String>] used DLLs.
    attr_reader :modules

    ##
    # @return [String, nil] name of app package name.
    attr_reader :package_name

    ##
    # Initialize new process.
    #
    # @param options [Hash]
    #
    # @option options [String] image_name name of the executable.
    # @option options [Integer] pid process ID.
    # @option options [String, nil] session_name session name.
    # @option options [Integer, nil] session session number.
    # @option options [Integer, nil] mem_usage memory usage in KB.
    # @option options [String, nil] status process status.
    # @option options [String, nil] user_name user which started process.
    # @option options [String, nil] cpu_time process runtime.
    # @option options [String, nil] window_title title of process window.
    # @option options [Array<String>, nil] services services.
    # @option options [Array<String>, nil] modules used DLLs.
    # @option options [String, nil] package_name name of app package name.
    def initialize(options)
      @image_name   = options[:image_name].to_s
      @pid          = options[:pid].to_i
      @session_name = options[:session_name] ? options[:session_name].to_s                     : nil
      @session      = options[:session]      ? options[:session].to_i                          : nil
      @mem_usage    = options[:mem_usage]    ? options[:mem_usage].to_s.gsub(/[^\d]/, "").to_i : nil
      @status       = options[:status]       ? options[:status].to_s                           : nil
      @user_name    = options[:user_name]    ? options[:user_name].to_s                        : nil
      @cpu_time     = options[:cpu_time]     ? options[:cpu_time].to_s                         : nil
      @window_title = options[:window_title] ? options[:window_title].to_s                     : nil
      @services     = options[:services]     ? options[:services].to_s.split(",")              : []
      @modules      = options[:modules]      ? options[:modules].to_s.split(",")               : []
      @package_name = options[:package_name] ? options[:package_name].to_s                     : nil

      super(
        name: @image_name,
        pid: @pid,
        memory: @mem_usage
      )
    end

    ##
    # @return [String] PID and name of process.
    def to_s
      "Process ##{@pid} #{@image_name}"
    end

    ##
    # Inspect all stored data.
    #
    # @param [String] splitter
    #
    # @return [String] all accessable info in human-readable form.
    def inspect(splitter = "; ")
      to_s +
      (@session_name || @session ? "#{splitter}Session: #{@session_name}(#{@session})" : "") +
      (@mem_usage ? "#{splitter}Memory usage: #{@mem_usage} KB" : "") +
      (@status ? "#{splitter}Status: #{@status}" : "") +
      (@user_name || @cpu_time ? "#{splitter}Launched by: #{@user_name}, runs for #{@cpu_time}" : "") +
      (@window_title ? "#{splitter}Title: #{@window_title}" : "") + 
      (@services.empty? ? "" : "#{splitter}Services: #{@services.join(",")}") +
      (@modules.empty? ? "" : "#{splitter}Modules: #{@modules.join(",")}") +
      (@package_name ? "#{splitter}Package name: #{@package_name}" : "")
    end

    ##
    # Compare with other process by PID.
    def ==(other)
      WindowsProcess === other && other.pid == @pid
    end

  end

  ##
  # Class representing process in Unix.
  class LinuxProcess < Process

    ##
    # @return [String] command which launched process.
    attr_reader :comm

    ##
    # @return [Integer] process ID.
    attr_reader :pid

    ##
    # @return [String, nil] process status.
    attr_reader :stat

    ##
    # @return [String, nil] amount of time process is running.
    attr_reader :time

    ##
    # @return [Integer, nil] amount of used CPU memory in KB.
    attr_reader :rss

    ##
    # Initialize new process.
    #
    # @param options [Hash]
    #
    # @option options [String] comm command which launched process.
    # @option options [Integer] pid process ID.
    # @option options [String, nil] stat process status.
    # @option options [String, nil] time amount of time process is running.
    # @option options [Integer, nil] rss amount of used CPU memory in KB.
    def initialize(options)
      @comm = options[:comm].to_s
      @pid  = options[:pid].to_i
      @stat = options[:stat] ? options[:stat].to_s : nil
      @time = options[:time] ? options[:time].to_s : nil
      @rss  = options[:rss]  ? options[:rss].to_i  : nil

      super(
        name: @comm,
        pid: @pid,
        memory: @rss
      )
    end

    ##
    # @return [String] PID and command of process.
    def to_s
      "Process ##{@pid} #{@comm}"
    end

    ##
    # Inspect all stored data.
    #
    # @param [String] splitter
    #
    # @return [String] all accessable info in human-readable form.
    def inspect(splitter = "; ")
      to_s +
      (@stat ? "#{splitter}Status: #{@stat}" : "") +
      (@time ? "#{splitter}Time running: #{@time}" : "") +
      (@rss ? "#{splitter}Memory: #{@rss} KB" : "")
    end

    ##
    # Compare with other process by PID.
    def ==(other)
      LinuxProcess === other && other.pid == @pid
    end

  end

end
