require 'base64'

module ImaggaAutoTag
  
  class Client

    IMAGGA_API_BASE_URL = "https://api.imagga.com"
    IMAGGA_API_TAG_PATH = "/v1/tagging"

    attr_reader :response

    # Initialize a new client to fetch information from IMAGGA
    #
    # ==== Attributes
    # * +api_key+ `String` of your IMAGGA api key
    # * +api_secret+ `String` of your IMAGGA api secret
    #
    # ===== Examples
    # client = ImaggaAutoTag::Client.new(api_key, api_secret)
    def initialize(api_key, api_secret)
      @conn = Faraday.new(url: IMAGGA_API_BASE_URL)
      @conn.basic_auth api_key, api_secret
    end

    # Fetch the JSON information for a specific image
    #
    # ==== Attributes
    # * +url+ `String` of the image URL to analyse
    #
    # ==== Examples
    # # Create a new client
    # client = ImaggaAutoTag::Client.new(api_key, api_secret)
    # client.fetch(image_url_string)
    def fetch(url)
      @response = @conn.get IMAGGA_API_TAG_PATH, {url: url}

      TaggedImage.new(@response)
    end

  end

end