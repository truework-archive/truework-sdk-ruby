# frozen_string_literal: true

require 'truework/list_response'

describe Truework::ListResponse do
  let(:url) { 'https://api.truework.com' }
  let(:status_code) { 200 }
  let(:response) { Truework::ListResponse.new(url, status_code, http_body: body) }

  describe '.from_response' do
    let(:response) { Class.new.extend(Truework::HTTPRequest).get('') }
    let(:version) { '2019-10-15' }
    let(:headers) { { version: version } }
    subject { Truework::ListResponse.from_response(response) }

    before do
      stub_request(:get, url)
        .to_return(
          status: 200,
          headers: headers
        )
    end

    it 'should extract attributes' do
      expect(subject.status_code).to eq(200)
      expect(subject.url).to eq(response.uri)
      expect(subject.api_version).to eq(version)
    end
  end

  describe 'num_results' do
    let(:count) { 20 }
    let(:body) { JSON.generate(count: count) }
    subject { response.num_results }

    it 'should return count key from json data' do
      expect(subject).to eq(count)
    end

    context 'when the count is not in the json data' do
      let(:body) {}

      it 'should be nil' do
        expect(subject).to be_nil
      end
    end

    describe 'next_url' do
      let(:next_url) { "#{url}?page=2" }
      let(:body) { JSON.generate(next: next_url) }
      subject { response.next_url }

      it 'should return the next key from json data' do
        expect(subject).to eq(next_url)
      end

      context 'when the next key is not in json data' do
        let(:body) {}
        it 'should be nil' do
          expect(subject).to be_nil
        end
      end
    end
  end
end
