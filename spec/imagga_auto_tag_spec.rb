require 'spec_helper'

describe "An Imagga Auto Tag API" do
  
  context "client" do

    before(:each) do
      @client = ImaggaAutoTag::Client.new(ENV['IMAGGA_API_KEY'], ENV['IMAGGA_API_SECRET'])
    end

    it "connects" do
      VCR.use_cassette('image') do
        expect {
          results = @client.fetch("http://static.ddmcdn.com/gif/landscape-photography-1.jpg")
        }.not_to raise_error
      end
    end

  end

  context "result" do
    
    before do
      VCR.use_cassette('image') do
        @client = ImaggaAutoTag::Client.new(ENV['IMAGGA_API_KEY'], ENV['IMAGGA_API_SECRET'])
        @results = @client.fetch("http://static.ddmcdn.com/gif/landscape-photography-1.jpg")
      end
    end

    it "returns a tagged image object" do
      expect(@results).to be_an_instance_of(ImaggaAutoTag::TaggedImage)
    end

    it "has a status code" do
      expect(@results.status).to be 200
    end

    it "has tags" do
      expect(@results.tags[0]).to be_an_instance_of(ImaggaAutoTag::Tag)
    end

    it "has tags with a confidence and name" do
      expect(@results.tags[0].name).to be_an_instance_of(String)
      expect(@results.tags[0].confidence).to be_an_instance_of(Float)
    end

    it "drops tags under a certain threshold if scrubbed" do
      number_of_tags = @results.tags.size

      @results.scrub

      expect(@results.tags.size).to be < number_of_tags
    end

    it "converts tags into a comma delimitted string" do
      expect(@results.to_csv).to be_an_instance_of(String)
    end

  end

  context "error" do
    before do
      @test = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get("http://static.ddmcdn.com/gif/landscape-photography-1.jpg") { |env| [403, {}, '{
            "status": "error",
            "message": "You have reached your monthly limits for this subscription.",
            "type": "monthly_limit_reached"
          }'] }
          stub.get("http://static.ddmcdn.com/gif/landscape-photography-2.jpg") { |env| [403, {}, '{
            "status": "error",
            "message": "You have reached your monthly limits for this subscription."
          }'] }
        end
      end
    end

    it "raise an imagga error" do
      resp = @test.get("http://static.ddmcdn.com/gif/landscape-photography-1.jpg")

      expect { ImaggaAutoTag::TaggedImage.new(resp) }.to raise_error ImaggaAutoTag::ImaggaError,
                                                                     "You have reached your monthly limits for this subscription."
    end

    it "contains stirng as an error type" do
      resp = @test.get("http://static.ddmcdn.com/gif/landscape-photography-1.jpg")

      expect { ImaggaAutoTag::TaggedImage.new(resp) }.to raise_error { |error|
                                                            expect(error.type).to eq "monthly_limit_reached"
                                                         }
    end

    it "contains nil as an error type" do
      resp = @test.get("http://static.ddmcdn.com/gif/landscape-photography-2.jpg")

      expect { ImaggaAutoTag::TaggedImage.new(resp) }.to raise_error { |error|
                                                           expect(error.type).to eq nil
                                                         }
    end
  end

end