module ImaggaAutoTag

  class ImaggaError < StandardError

    attr_reader :type

    # Initiliaze a new imagga error.
    # Can contain the error typw
    def initialize(error_type)
      @type = error_type
    end

  end

end