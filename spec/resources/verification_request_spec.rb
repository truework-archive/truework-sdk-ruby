# frozen_string_literal: true

describe Truework::VerificationRequest do
  describe 'initialize' do
    let(:id) { 'AAAAAAAAQnIAAYd5YHFVOm8PNX2ecFbEjqV__upOKUE8YE_IK2GwSQTP1' }
    let(:created) { DateTime.new(2019, 1, 1) }
    subject { Truework::VerificationRequest.new(id: id, created: created) }

    context 'when required values are nil' do
      context 'when id is nil' do
        let(:id) {}

        it 'should raise an error' do
          expect { subject }.to raise_error(Dry::Struct::Error, /:id/)
        end
      end

      context 'when created is nil' do
        let(:created) {}

        it 'should raise an error' do
          expect { subject }.to raise_error(Dry::Struct::Error, /:created/)
        end
      end
    end

    context 'default values' do
      it 'should default all non required attributes to nil' do
        %i[
          type
          turnaround_time
          permissible_purpose
          target
          state
          documents
        ].each do |attr|
          expect(subject.send(attr)).to be_nil
        end
      end
    end

    context 'nested attributes' do
      let(:state) { 'completed' }
      subject do
        Truework::VerificationRequest.new(
          id: id,
          created: created,
          state: state,
          **additional_params
        )
      end

      describe 'price' do
        let(:amount) { '5' }
        let(:currency) { 'USD' }
        let(:additional_params) { { price: { amount: amount, currency: currency } } }

        it 'should deserialize price into a Truework::Price object' do
          expect(subject.price).to be_a(Truework::Price)
          expect(subject.price.amount).to eq(amount.to_d)
          expect(subject.price.currency).to eq(currency)
        end
      end

      describe 'turnaround_time' do
        let(:upper_bound) { 42 }
        let(:lower_bound) { 32 }
        let(:additional_params) { { turnaround_time: { upper_bound: upper_bound, lower_bound: lower_bound } } }

        it 'should deserialize turnaround_time into a Truework::TurnaroundTime object' do
          expect(subject.turnaround_time).to be_a(Truework::TurnaroundTime)
          expect(subject.turnaround_time.upper_bound).to eq(upper_bound)
          expect(subject.turnaround_time.lower_bound).to eq(lower_bound)
        end
      end

      describe 'target' do
        let(:first_name) { 'John' }
        let(:last_name) { 'Smith' }
        let(:contact_email) { 'john.smith@truework.com' }
        let(:company) { { name: 'Truework' } }
        let(:additional_params) do
          { target: { first_name: first_name, last_name: last_name, contact_email: contact_email, company: company } }
        end

        it 'should deserialize target into a Truework::Target object' do
          expect(subject.target).to be_a(Truework::Target)
          expect(subject.target.first_name).to eq(first_name)
          expect(subject.target.last_name).to eq(last_name)
          expect(subject.target.contact_email).to eq(contact_email)
        end

        it 'should deserialize the nested company object into a Truework::Company object' do
          expect(subject.target.company).to be_a(Truework::Company)
          expect(subject.target.company.name).to eq('Truework')
        end
      end

      describe 'documents' do
        let(:documents) { [{ filename: '1.pdf' }, { filename: '2.pdf' }] }
        let(:additional_params) { { documents: documents } }

        it 'should deserialize documents into an array of Truework::Document objects' do
          expect(subject.documents[0]).to be_a(Truework::Document)
          expect(subject.documents[0].filename).to eq('1.pdf')
          expect(subject.documents[1].filename).to eq('2.pdf')
        end
      end
    end
  end

  describe '.cancel' do
    let(:id) { 'AAAAAAAAQnIAAYd5YHFVOm8PNX2ecFbEjqV__upOKUE8YE_IK2Gw2CAN' }
    let(:cancellation_reason) { 'other' }
    let(:cancellation_details) { 'The verification request is no longer needed.' }
    subject { Truework::VerificationRequest.cancel(id, cancellation_reason, cancellation_details) }

    context 'when successful' do
      before do
        stub_request(:put, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}#{id}/cancel/")
          .with(
            body: {
              'cancellation_reason' => cancellation_reason,
              'cancellation_details' => cancellation_details
            }
          )
          .to_return(
            status: 200,
            body: fixture('verification_requests/verification_request_cancel_response.json')
          )
      end

      it 'should return a VerificationRequest object' do
        expect(subject).to be_a(Truework::VerificationRequest)
      end

      it 'should deserialize the response correctly' do
        expected = Truework::VerificationRequest.new(
          id: id,
          state: 'cancelled',
          created: DateTime.new(2008, 9, 15, 15, 53, 0),
          cancellation_reason: 'other',
          cancellation_details: 'The verification request is no longer needed.',
          type: 'employment-income',
          permissible_purpose: 'credit-application',
          price: Truework::Price.new(amount: 0.00, currency: 'USD'),
          turnaround_time: Truework::TurnaroundTime.new,
          target: Truework::Target.new(
            company: Truework::Company.new(name: 'Future Widget LLC'),
            first_name: 'Joe',
            last_name: 'Smith',
            contact_email: 'joesmith@example.org'
          ),
          documents: [Truework::Document.new(filename: 'employee_authorization.pdf')]
        )
        expect(subject).to eq(expected)
      end
    end
  end

  describe '.retrieve' do
    let(:id) { 'AAAAAAAAQnIAAYd5YHFVOm8PNX2ecFbEjqV__upOKUE8YE_IK2GwSQTP' }
    subject { Truework::VerificationRequest.retrieve(id) }

    context 'when successful' do
      before do
        stub_request(:get, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}#{id}/")
          .to_return(
            status: 200,
            body: fixture('verification_requests/verification_request_retrieve_response.json')
          )
      end

      it 'should return a VerificationRequest object' do
        expect(subject).to be_a(Truework::VerificationRequest)
      end

      it 'should deserialize the response correctly' do
        expected = Truework::VerificationRequest.new(
          id: id,
          state: 'completed',
          created: DateTime.new(2008, 9, 15, 15, 53, 0),
          type: 'employment-income',
          loan_id: '12345',
          permissible_purpose: 'credit-application',
          price: Truework::Price.new(amount: 39.95, currency: 'USD'),
          turnaround_time: Truework::TurnaroundTime.new,
          target: Truework::Target.new(
            company: Truework::Company.new(name: 'Future Widget LLC'),
            first_name: 'Joe',
            last_name: 'Smith',
            contact_email: 'joesmith@example.org'
          ),
          documents: [Truework::Document.new(filename: 'employee_authorization.pdf')]
        )
        expect(subject).to eq(expected)
      end
    end

    context 'when not found' do
      let(:id) { 'bad_id' }
      before do
        stub_request(:get, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}#{id}/")
          .to_return(status: 404)
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(Truework::NonExistentRecord)
      end
    end
  end

  describe '.create' do
    let(:payload) do
      {
        type: 'employment-income',
        permissible_purpose: 'risk-assessment',
        target: {
          first_name: 'Joe',
          last_name: 'Smith',
          social_security_number: '000-00-0000',
          contact_email: 'joesmith@example.org',
          company: { name: 'Future Widget Company' }
        },
        documents: [
          {
            filename: 'employee_authorization.pdf',
            content: 'iVBORw0KGgoAAAANSUhEUg......IhAAAAABJRU5ErkJggg=='
          }
        ]
      }
    end
    let(:verification_request) { Truework::VerificationRequest.create(payload) }
    subject { verification_request }

    context 'when successful' do
      before do
        stub_request(:post, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}")
          .to_return(
            status: 200,
            body: fixture('verification_requests/verification_request_response.json')
          )
      end

      it 'should return a Truework::VerificationRequest object' do
        expect(subject).to be_a(Truework::VerificationRequest)
      end

      context 'nested attributes' do
        describe 'turnaround_time' do
          subject { verification_request.turnaround_time }

          it 'should deserialize the turnaround time into a Truework::TurnaroundTime object' do
            expect(subject).to be_a(Truework::TurnaroundTime)
          end

          it 'should convert the nested attributes correctly' do
            expect(subject.lower_bound).to eq(23)
            expect(subject.upper_bound).to eq(42)
          end
        end

        describe 'target' do
          subject { verification_request.target }

          it 'should deserialize the target into a Truework::Target object' do
            expect(subject).to be_a(Truework::Target)
          end

          it 'should convert the nested attributes correctly' do
            expect(subject.first_name).to eq('Joe')
            expect(subject.last_name).to eq('Smith')
            expect(subject.contact_email).to eq('joesmith@example.org')
          end

          context 'nested attribute' do
            subject { verification_request.target.company }

            it 'should deserialize the company into a Truework::Company object' do
              expect(subject).to be_a(Truework::Company)
            end

            it 'should convert the nested attributes correctly' do
              expect(subject.name).to eq('Future Widget LLC')
            end
          end
        end
      end

      describe 'documents' do
        subject { verification_request.documents }

        it 'should deserialize the documents into an array of Truework::Document objects' do
          expect(subject.first).to be_a(Truework::Document)
        end

        it 'should convert the nested attributes correctly' do
          expect(subject.first.filename).to eq('employee_authorization.pdf')
        end
      end
    end

    context 'when it is unsuccessful' do
      before do
        stub_request(:post, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}")
          .to_return(status: 400)
      end

      it 'should raise an exception' do
        expect { subject }.to raise_error(Truework::BadRequest)
      end
    end
  end

  describe '.list' do
    subject { Truework::VerificationRequest.list }

    before do
      stub_request(:get, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}")
        .to_return(
          status: 200,
          body: fixture('verification_requests/verification_request_list_response.json')
        )
    end

    it 'should return a ListResponse' do
      expect(subject).to be_kind_of(Truework::ListResponse)
    end

    it 'should have a status code of 200' do
      expect(subject.status_code).to eq(200)
    end

    it 'should convert the response into Truework::VerificationRequest objects' do
      expect(subject.data.length).to eq(5)
      verification_request = Truework::VerificationRequest.new(
        id: 'AAAAAAAAQnIAAYd5YHFVOm8PNX2ecFbEjqV__upOKUE8YE_IK2GwSQTP1',
        state: 'pending-approval',
        created: DateTime.new(2008, 9, 15, 15, 53, 0o0),
        type: 'employment-income',
        loan_id: '12345',
        permissible_purpose: 'credit-application',
        price: Truework::Price.new(amount: 39.95, currency: 'USD'),
        turnaround_time: Truework::TurnaroundTime.new,
        target: Truework::Target.new(
          company: Truework::Company.new(name: 'Admazely'),
          first_name: 'John',
          last_name: 'Doe',
          contact_email: 'johndoe@truework.com'
        ),
        documents: [Truework::Document.new(filename: 'employee_authorization.pdf')]
      )

      expect(subject.data[0]).to eq(verification_request)
    end
  end
end
