module ProcessObserver

  ##
  # Module with exceptions which might be raised.
  module Exceptions

    ##
    # String contains some special character which is not allowed.
    class SpecialCharacterError < ArgumentError; end
    
    ##
    # This platform is currently unsupported.
    class UnsupportedPlatformError < ArgumentError; end

    ##
    # Expected to see single process.
    class MultipleProcessError < RuntimeError; end

    ##
    # UTF-8 encoding is required.
    class EncodingError < RuntimeError; end

  end

  include Exceptions

end
