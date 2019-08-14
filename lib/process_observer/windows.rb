require "csv"

module ProcessObserver

  ##
  # Module with methods to interact with Windows.
  module Windows

    ##
    # Task list executable
    EXE = "tasklist"

    ##
    # Method to turn hash with call parameters into call string argument.
    #
    # @note: this method currently raises error when meet string with double quote.
    #
    # @param hash [Hash] not empty hash.
    #
    # @return [String]
    def self.to_arg(hash)
      raise ArgumentError, "Empty hash", caller if hash.empty?

      hash.map do |key, value|
        case value
          when TrueClass, FalseClass, NilClass # Boolean or nil
            value ? "/#{key}" : ""
          when String
            raise Exceptions::SpecialCharacterError, "Please don't use double quotes in string", caller if value.include?('"')
            "/#{key} \"#{value}\""
          else
            "/#{key} #{value}"
        end
      end
      .join(" ").strip.gsub(/\s+/, " ")
    end

    ##
    # Call task list executable with provided options
    #
    # @param options [Hash] hash with call options
    #
    # @option options [Boolean] svc (false) return services for each process.
    # @option options [Boolean] apps (false) return store processes.
    # @option options [Boolean] v (false) return extended info.
    # @option options [true, String, nil] m (nil) return tasks using given module or all modules if +true+.
    # @option options [String, nil] fi (nil) filter.
    # @option options [:csv, :table, :list] fo (:csv) format of output.
    #   if +:csv+ is chosen output will be parsed with CSV library and
    #   returned as array of {Process}, otherwise whole string will be returned.
    #
    # @return [String, Array<Process>] call output
    def self.call(options = {})
      call_params = {}
      call_params[:svc]  = !!options[:svc]
      call_params[:apps] = !!options[:apps]
      call_params[:v]    = !!options[:v]
      case 
        when options[:m].nil?    then call_params[:m] = nil
        when options[:m] == true then call_params[:m] = true
        else call_params[:m] = options[:m].to_s
      end
      call_params[:fi]   = options[:fi].to_s unless options[:fi].nil?

      call_params[:fo]   = options[:fo] || :csv
      raise ArgumentError, "Unknown format option #{call_params[:fo]}", caller unless [:csv, :table, :list].include?(call_params[:fo])

      Log.debug "Call parameters: #{call_params}"
      command = call_params.empty? ? "#{EXE}" : "#{EXE} #{to_arg(call_params)}"
      Log.debug "Executing: #{command}"
      re = `#{command}`.chomp
      if call_params[:fo] == :csv
        csv = CSV.parse(re)
        enum = csv.to_a.drop(1) # Skip header
        case
          when call_params[:v] && call_params[:apps]
            # Extended info fow apps
            enum.map do |data|
              WindowsProcess.new(
                image_name: data[0],
                pid: data[1],
                session_name: data[2],
                session: data[3],
                mem_usage: data[4],
                status: data[5],
                user_name: data[6],
                cpu_time: data[7],
                window_title: data[8],
                package_name: data[9]
              )
            end
          when call_params[:v]
            # Extended info
            enum.map do |data|
              WindowsProcess.new(
                image_name: data[0],
                pid: data[1],
                session_name: data[2],
                session: data[3],
                mem_usage: data[4],
                status: data[5],
                user_name: data[6],
                cpu_time: data[7],
                window_title: data[8]
              )
            end
          when call_params[:apps]
            # Apps
            enum.map do |data|
              WindowsProcess.new(
                image_name: data[0],
                pid: data[1],
                mem_usage: data[2],
                package_name: data[3]
              )
            end
          when call_params[:m]
            # Modules
            enum.map do |data|
              WindowsProcess.new(
                image_name: data[0],
                pid: data[1],
                modules: data[2]
              )
            end
          when call_params[:svc]
            # Services
            enum.map do |data|
              WindowsProcess.new(
                image_name: data[0],
                pid: data[1],
                services: data[2]
              )
            end
          else
            # Regular mode
            enum.map do |data|
              WindowsProcess.new(
                image_name: data[0],
                pid: data[1],
                session_name: data[2],
                session: data[3],
                mem_usage: data[4]
              )
            end
        end
      else
        re.strip
      end
    end

  end

end
