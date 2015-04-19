# Recommendations API Client

API Client for Animata Recommendations service.

## Install

    gem 'recommendations_api_client'

## Configuration

    Recommendations.configure do |config|
      config.application = 'mts'
      config.api_endpoint = 'http://api.recommendations.animata.com'
      config.timeout = 5 # optional
      
      # Request/response headers and bodies will be logged to this logger,
      # no logging will happen by default.
      config.logger = Logger.new(STDOUT)
    end

## Usage

    personal_recs = Recommendations.recommendations(
      device_id: 'abcdef', 
      user_id: 123, 
      birthday: nil, 
      age: nil, 
      gender: nil, 
      country: nil, 
      platform: nil,
      seen: [], #item_ids
      items: [], 
      type: 'channel', 
      limit: 300,
      offset: 0)

    if personal_recs # personal_recs will be nil if the request timeout has expired
      puts "Recommendation id: #{personal_recs.id}"
      personal_recs.items.each do |recommended_item|
        puts "Item with id #{recommended_item.id} and type #{recommended_item.type} was recommended with score #{recommended_item.score}"
      end
    end

    item_recs = Recommendations.similar(
      device_id: 'abcdef',
      user_id: 123, 
      item_id: 'russia2',
      limit: 300,
      offset: 0 
    )

    if item_recs # item_recs will be nil if the request timeout has expired
      puts "Recommendation id: #{item_recs.id}"
      item_recs.items.each do |recommended_item|
        puts "Item with id #{recommended_item.id} and type #{recommended_item.type} was recommended with score #{recommended_item.score}"
      end
    end

## Contributing

1. Create your feature branch (`git checkout -b my-new-feature`)
2. Commit your changes (`git commit -am 'Add some feature'`)
3. Push to the branch (`git push origin my-new-feature`)
4. Create a new Pull Request