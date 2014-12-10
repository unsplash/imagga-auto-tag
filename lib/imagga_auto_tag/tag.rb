module ImaggaAutoTag

  class Tag

    attr_reader :confidence, :name

    def initialize(raw_data)
      @confidence = raw_data['confidence']
      @name = raw_data['tag']
    end

  end

end