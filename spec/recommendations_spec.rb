RSpec.describe Recommendations do
  before { Recommendations.config.api_endpoint = 'http://example.com' }
  
  describe '.client' do
    it 'creates a client' do
      expect(Recommendations.client).to be_kind_of Recommendations::Client
    end
    it 'caches the client when the same options are passed' do
      expect(Recommendations.client).to eq(Recommendations.client)
    end
    it 'returns a fresh client when options are not the same' do
      client = Recommendations.client
      Recommendations.config.api_endpoint = 'spbtv.com'
      expect(client).not_to eq(Recommendations.client)
      expect(Recommendations.client).to eq(Recommendations.client)
    end
  end

  describe 'methods delegation' do
    class Recommendations::Client
      def delegation_test
        1
      end
    end
    it 'responds to client methods' do
      expect(Recommendations.respond_to?(:delegation_test)).to eq true
    end
    it 'delegates methods to the client' do
      expect(Recommendations.delegation_test).to eq 1
    end
  end

  describe '.ensure_properly_configured' do
    before do
      Recommendations::REQUIRED_CONFIG_OPTIONS.each do |option|
        Recommendations.config.send("#{option}=", nil)
      end
    end
    it 'ensures empty configuration is invalid' do
      expect { Recommendations.ensure_properly_configured! }.to raise_error(
        Recommendations::ConfigurationError,
        'api_endpoint, application config options required, see README.'
      )
    end
  end
end