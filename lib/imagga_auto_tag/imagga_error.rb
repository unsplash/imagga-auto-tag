module ImaggaAutoTag

  class ImaggaError < StandardError

    attr_reader :type

    def initialize(error_type)
      @type = error_type
    end

  end

end