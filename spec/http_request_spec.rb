# frozen_string_literal: true

require 'truework/http_request'

describe Truework::HTTPRequest do
  let(:subject_class) { Class.new { extend Truework::HTTPRequest } }
  let(:path) { '/some_path/' }
  let(:url) { "#{Truework.api_base}#{path}" }

  describe 'build_request' do
    subject { subject_class.send(:build_request, :get, URI.parse(url), {}) }

    it 'sets the content type as json' do
      expect(subject['Content-Type']).to eq('application/json')
    end

    it 'sets the user agent' do
      expect(subject['User-Agent']).to start_with('Truework')
    end

    it 'sets the authorization token' do
      expect(subject['Authorization']).to start_with('Bearer')
    end

    it 'adds a default accept header' do
      expect(Truework.api_version).to be_nil
      expect(subject['Accept']).to eq('application/json')
    end

    context 'when the api version is set' do
      before do
        Truework.api_version = '2019-10-15'
      end

      it 'should add the version to the accept header' do
        expect(subject['Accept']).to eq("application/json; version=#{Truework.api_version}")
      end
    end
  end

  describe 'exceptions' do
    subject { subject_class.get(path, {}) }
    let(:status) { 200 }
    let(:body) { '{}' }

    before do
      stub_request(:get, url)
        .to_return(
          status: status,
          body: body
        )
    end
    context 'when 200' do
      it 'should not error out' do
        expect { subject }.to_not raise_exception
      end
    end

    shared_examples 'mapped exception handler' do
      it 'should throw the correct exception' do
        expect { subject }.to raise_exception(exception)
      end
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 400 }
      let(:exception) { Truework::BadRequest }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 401 }
      let(:exception) { Truework::InvalidCredentials }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 404 }
      let(:exception) { Truework::NonExistentRecord }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 409 }
      let(:exception) { Truework::RecordAlreadyExists }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 500 }
      let(:exception) { Truework::InternalServerError }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 502 }
      let(:exception) { Truework::BadGateway }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 503 }
      let(:exception) { Truework::ServiceUnavailable }
    end

    it_behaves_like 'mapped exception handler' do
      let(:status) { 504 }
      let(:exception) { Truework::GatewayTimeout }
    end

    context 'when it is an unmapped error' do
      let(:status) { 429 }
      let(:exception) { Truework::UnexpectedHTTPException }

      it_behaves_like 'mapped exception handler'
    end
  end
end
