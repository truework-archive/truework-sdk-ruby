# frozen_string_literal: true

require 'truework/api_response'

describe Truework::APIResponse do
  let(:url) { 'https://api.truework.com' }
  let(:status_code) { 200 }
  let(:response) { Truework::APIResponse.new(url, status_code, http_body: body) }

  describe '.from_response' do
    let(:response) { Class.new.extend(Truework::HTTPRequest).get('') }
    let(:version) { '2019-10-15' }
    let(:headers) { { version: version } }
    subject { Truework::APIResponse.from_response(response) }

    before do
      stub_request(:get, url)
        .to_return(
          status: 200,
          body: JSON.generate(some: 'body'),
          headers: headers
        )
    end

    it 'should extract attributes' do
      expect(subject.status_code).to eq(200)
      expect(subject.url).to eq(response.uri)
      expect(subject.json).to eq(some: 'body')
      expect(subject.api_version).to eq(version)
    end
  end

  describe 'json' do
    let(:body) { JSON.generate(a: 1) }

    it 'should decode json' do
      expect(response.json).to eq(a: 1)
    end
  end
end
