module ImaggaAutoTag
  
  class TaggedImage

    attr_reader :status, :tags

    def initialize(api_response)
      # The response from Imagga is now wrap in a results envelop
      #
      # ==== Result
      # { "results" => [{ "image" => "", "tags" => [{}, {}, {}] }] }
      body = JSON.parse(api_response.body)

      @tags = []

      body['results'][0]['tags'].each do |tag|
        @tags.push Tag.new(tag)
      end

      @status = api_response.status
    end

    def scrub(threshold = 30)
      @tags.select! do |tag|
        tag.confidence > threshold
      end
    end

    def to_csv
      @tags.collect { |t| t.name }.join(',')
    end

  end

end