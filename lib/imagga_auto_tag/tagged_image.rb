module ImaggaAutoTag
  
  class TaggedImage

    attr_reader :status, :tags

    def initialize(api_response)

      # The response from Imagga is now wrap in a results envelop
      #
      # ==== Result
      # success:
      # { "results" => [{ "image" => "", "tags" => [{}, {}, {}] }] }
      # failure:
      # { "results" => [], "unsuccessful" => [{ "image" => url, "message" => msg }]}
      body = JSON.parse(api_response.body)

      raise ImaggaError.new(body['type']), body['message'] unless api_response.status.between?(200, 299)

      @tags = []

      (body['results'][0] || {}).fetch('tags', []).each do |tag|
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
      @tags.collect(&:name).join(',')
    end

  end

end