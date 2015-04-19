require 'faraday'
require 'faraday_middleware'
require 'active_support/core_ext/hash/keys'
require 'timeout'

module Recommendations
  class Client
    attr_reader :config

    def initialize(config = {})
      @config = config
      @timeout = config.fetch(:timeout)

      url = "#{config.fetch(:api_endpoint).chomp('/')}/v2/"
      @connection = Faraday.new(url: url) do |conn|
        conn.request :url_encoded
        conn.response :json
        conn.response :logger, config.fetch(:logger), bodies: true
        conn.adapter config.fetch(:adapter, Faraday.default_adapter)
      end
    end

    def recommendations(device_id: nil, user_id: nil, 
      birthday: nil, age: nil, gender: nil, country: nil, platform: nil,
      seen: nil, items: nil, type: nil, limit: 300, offset: 0)
      params = params_hash(__method__) { |arg| eval(arg) }
      structured_result(get('recommendations', params))
    end

    def similar(item_id:, user_id: nil, device_id: nil, limit: 300, offset: 0)
      params = params_hash(__method__) { |arg| eval(arg) }
      structured_result(get('similar', params))
    end

    private

    def params_hash(method)
      params = { application: @config.fetch(:application) }
      arguments(method).each do |arg|
        arg_value = yield(arg)
        params[arg.to_sym] = arg_value if arg_value
      end
      params
    end

    def arguments(method)
      self.class.instance_method(method).parameters.map(&:last).map(&:to_s)
    end

    def structured_result(result)
      return nil unless result
      rec_id = result[:recommendation_id]
      rec_items = (result[:items] || []).map { |rec| RecommendedItem.new(*rec.values) }
      Recommendation.new(rec_id, rec_items)
    end

    def get(url, params = {})
      begin
        status = Timeout::timeout(@timeout) do
          response = @connection.get(url, params)
          symbolize(response.body)
        end  
      rescue Timeout::Error => e
        nil
      end
    end

    def symbolize(response)
      case response
      when Array then response.map(&:deep_symbolize_keys)
      else response.deep_symbolize_keys
      end
    end
  end
end