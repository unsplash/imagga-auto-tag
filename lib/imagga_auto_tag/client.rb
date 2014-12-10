module ImaggaAutoTag
  
  class Client

    IMAGGA_API_BASE_URL = "https://api.imagga.com" || ENV['IMAGGA_API_BASE_URL']
    IMAGGA_API_TAG_PATH = "/draft/tags" || ENV['IMAGGA_API_TAG_PATH']

    attr_reader :response

    def initialize(api_key)
      @api_key = api_key
      @conn = Faraday.new(:url => IMAGGA_API_BASE_URL)
    end

    def fetch(url)
      @response = @conn.get do |req|
        req.url IMAGGA_API_TAG_PATH
        req.params['api_key'] = @api_key
        req.params['url'] = url
      end

      TaggedImage.new(@response)
    end

  end

end