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

      unless api_response.status.between?(200, 299)
        raise ImaggaError.new(body['type']), body['message']
      end

      @tags = []
      @status = api_response.status
      results = body['results']

      return unless results.any?

      result = results.first || {}

      result.fetch('tags', []).each do |tag|
        @tags << Tag.new(tag)
      end
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
