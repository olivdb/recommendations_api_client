require 'vcr'

RSpec.describe Recommendations::Client do
  VALID_CONTENT_TYPES = %w(series movie channel program)

  shared_examples_for "a structured recommendation" do
    it { expect(subject).to be_kind_of(Recommendations::Recommendation) }
    it { expect(subject.id).to be_kind_of(String) }
    it { expect(subject.items).not_to be_empty }
  end

  shared_examples_for "a recommended item" do
    it { expect(subject).to be_kind_of(Recommendations::RecommendedItem) }
    it { expect(subject.id).to be_kind_of(String) }
    it { expect(VALID_CONTENT_TYPES).to include(subject.type) }
    it { expect(subject.score).to be_a(Numeric) }
  end

  before do
    Recommendations.configure do |config|
      config.api_endpoint = 'http://api.recommendations.spbtv.com'
    end
  end

  describe '.recommendations' do
    let(:type) { 'channel' }
    let(:app) { 'spbtv' }

    subject(:recommendations) do
      VCR.use_cassette('recommendations') do
        Recommendations.configure { |config| config.application = app }
        Recommendations.recommendations(
          device_id: nil,
          type: type)
      end
    end

    it_should_behave_like "a structured recommendation"
    describe 'recommended item' do
      subject(:recommended_item) { recommendations.items.sample }
      it_should_behave_like "a recommended item"
      it { expect(subject.type).to eq(type) }
    end
  end

  describe '.similar' do
    let(:item_id) { 'russia1' }
    let(:device_id) { '0003a702-1f95-44b7-b2d3-e1b68047d947' }
    let(:app) { 'mts' }

    subject(:similar) do
      VCR.use_cassette('similar') do
        Recommendations.configure { |config| config.application = app }
        Recommendations.similar(
          item_id: item_id,
          device_id: device_id)
      end
    end

    it_should_behave_like "a structured recommendation"
    describe 'recommended item' do
      subject(:recommended_item) { similar.items.sample }
      it_should_behave_like "a recommended item"
    end
  end
end