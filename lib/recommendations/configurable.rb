require 'logger'
require 'active_support/configurable'

module Recommendations
  REQUIRED_CONFIG_OPTIONS = %w[api_endpoint application]
  ConfigurationError = Class.new(StandardError)

  module Configurable
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Configurable

      config_accessor(:logger) { Logger.new('/dev/null') }
      config_accessor(:application)
      config_accessor(:api_endpoint)
      config_accessor(:timeout) { 5 }
    end

    class_methods do
      def ensure_properly_configured!
        not_configured = REQUIRED_CONFIG_OPTIONS.select do |option|
          config[option].nil?
        end
        if not_configured.any?
          raise ConfigurationError, "#{not_configured.join(', ')} config options required, see README."
        end
      end
    end
  end
end