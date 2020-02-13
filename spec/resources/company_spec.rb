# frozen_string_literal: true

describe Truework::Company do
  let(:id) { 1 }
  let(:name) { 'some name' }
  let(:domain) { 'truework.com' }
  subject { Truework::Company.new(id: id, name: name, domain: domain) }

  describe 'initialize' do
    context 'defaults' do
      subject { Truework::Company.new(name: name) }

      context 'id' do
        it 'should default to nil' do
          expect(subject.id).to be_nil
        end
      end

      context 'domain' do
        it 'should be nil' do
          expect(subject.domain).to be_nil
        end
      end
    end

    context 'when name is missing' do
      subject { Truework::Company.new }

      it 'should throw an error' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end

    context 'when values are given' do
      it 'should set instance values' do
        expect(subject.id).to eq(id)
        expect(subject.name).to eq(name)
        expect(subject.domain).to eq(domain)
      end

      context 'when strings are given' do
        subject { Truework::Company.new('id' => id, 'name' => name, 'domain' => domain) }

        it 'should set instance values' do
          expect(subject.id).to eq(id)
          expect(subject.name).to eq(name)
          expect(subject.domain).to eq(domain)
        end
      end
    end
  end

  describe 'list' do
    let(:query) { 'International' }
    subject { Truework::Company.list(q: query) }

    context 'an there is an invalid token' do
      subject { Truework::Company.list }
      before do
        Truework.api_key = 'invalid'
        stub_request(:get, "#{Truework.api_base}#{Truework::Company.resource_path}")
          .to_return(
            status: 400,
            body: fixture('company/invalid_token.json')
          )
      end

      it 'should raise an error' do
        expect { subject }.to raise_error(Truework::BadRequest)
        expect { subject }.to raise_error(/Invalid token/)
      end
    end

    context 'when successful' do
      before do
        stub_request(:get, "#{Truework.api_base}#{Truework::Company.resource_path}?q=#{query}")
          .to_return(
            status: 200,
            body: fixture('company/search_auto_paginate_page1.json')
          )
      end

      it 'should return a ListResponse' do
        expect(subject).to be_kind_of(Truework::ListResponse)
      end

      it 'should have a status code of 200' do
        expect(subject.status_code).to eq(200)
      end

      it 'should convert the response into Company objects' do
        expect(subject.data.length).to eq(2)
        expected_company = Truework::Company.new(
          id: 745,
          name: 'International Academy of Design and Technology',
          domain: 'iadt.edu'
        )
        expect(subject.data[0]).to eq(expected_company)
      end
    end
  end
end
