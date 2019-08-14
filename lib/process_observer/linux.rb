module ProcessObserver

  ##
  # Module with methods to interact with Linux.
  module Linux

    ##
    # Process list executable.
    EXE = "ps"

    ##
    # Output format.
    OUTPUT_FORMAT = "-o \"pid,comm,stat,time,rss\""

    ##
    # Call processes list executable with provided options string.
    #
    # @param options [String] options string.
    #
    # @return [Array<Process>] array of processes.
    def self.call(options = "-A")
      raise ArgumentError, "Provide options string", caller if options.to_s.empty?
      command = "#{EXE} #{options} #{OUTPUT_FORMAT}"
      Log.debug "Executing: #{command}"
      re = `#{command}`.chomp
      csv = CSV.parse(re.each_line.map { |line| line.strip.squeeze(" ") }.join("\n"), col_sep: " ")

      enum = csv.to_a.drop(1) # Skip header
      enum.map do |data|
        LinuxProcess.new(
          pid:  data[0],
          comm: data[1],
          stat: data[2],
          time: data[3],
          rss:  data[4]
        )
      end
    end

  end

end
