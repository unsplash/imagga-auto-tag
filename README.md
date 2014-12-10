# ImaggaAutoTag

A super simple wrapper for fetching tags for an image URL from the [Imagga Auto Tagging API](http://imagga.com/solutions/auto-tagging.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'imagga_auto_tag'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install imagga_auto_tag

## Usage

```ruby
client = ImaggaAutoTag::Client.new(your_imagga_api_key)
results = client.fetch("http://static.ddmcdn.com/gif/landscape-photography-1.jpg")

results.tags
# => array of tags

results.scrub(30)
# => array of tags with a confidence over 30%

results.tags[0].tap do |tag|
  tag.name # => tag name
  tag.confidence # => tag confidence as a float
end

results.to_csv
# => comma delimitted string of tag names
# => 'tag 1 name, tag 2 name, etc..'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/imagga_auto_tag/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
