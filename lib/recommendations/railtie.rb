module Recommendations
  class Railtie < Rails::Railtie
    initializer :logging do
      Recommendations.config.logger = Rails.logger
    end

    after_initialize do
      Recommendations.ensure_properly_configured!
    end
  end
end
