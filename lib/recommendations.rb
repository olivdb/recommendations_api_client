require 'active_support/core_ext/module/delegation'
require 'faraday'
require 'recommendations/configurable'
require 'recommendations/client'

module Recommendations
  include Configurable

  Recommendation = Struct.new(:id, :items)
  RecommendedItem = Struct.new(:id, :type, :score)

  class << self
    def client
      @client = Client.new(config.to_hash.dup) unless defined?(@client) && config.to_hash == @client.config
      @client
    end

    private

    def method_missing(name, *args, &block)
      if client.respond_to?(name)
        delegate name, to: :client
        client.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      client.respond_to?(name, include_private) || super
    end
  end
end

require 'card_payments/railtie' if defined?(Rails)
