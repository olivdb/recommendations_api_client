Gem::Specification.new do |spec|
  spec.name = 'recommendations_api_client'
  spec.version = '0.0.0'
  spec.date = '2015-03-27'
  spec.summary = 'API client for Animata recommendations service'
  spec.authors = ['Olivier van den Biggelaar']

  spec.files = Dir['{lib}/**/*']
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'activesupport', '~> 4.0'
  spec.add_dependency 'faraday', '~> 0.9.1'
  spec.add_dependency 'faraday_middleware', '~> 0.9.0'
end