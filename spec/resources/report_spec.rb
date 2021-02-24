# frozen_string_literal: true

describe Truework::Report do
  describe 'initialize' do
    let(:report_json) { JSON.parse(File.read(fixture('report/report_1.json')), symbolize_names: true) }
    let(:report) { Truework::Report.new(**report_json) }

    describe '.initialize' do
      context 'when created is nil' do
        it 'should raise an error' do
          expect { Truework::Report.new(**report_json, created: nil) }.to raise_error(Dry::Struct::Error, /:created/)
        end
      end

      context 'when current_as_of is nil' do
        it 'should raise an error' do
          expect do
            Truework::Report.new(**report_json, current_as_of: nil)
          end.to raise_error(Dry::Struct::Error, /:current_as_of/)
        end
      end

      context 'nested attributes' do
        describe 'verification_request' do
          subject { report.verification_request }

          it 'should deserialize the verification request into a Truework::VerificationRequest object' do
            expect(subject).to be_a(Truework::VerificationRequest)
          end

          context 'when the verification_request is missing' do
            before do
              report_json.delete(:verification_request)
            end

            it 'should raise an exception' do
              expect { subject }.to raise_error(Dry::Struct::Error, /:verification_request/)
            end
          end

          it 'should convert the nested attributes correctly' do
            expect(subject.id).to eq('report_1')
            expect(subject.type).to eq('employment-income')
            expect(subject.created).to eq(DateTime.new(2008, 9, 14, 9))
          end
        end

        describe 'employer' do
          subject { report.employer }

          it 'should deserialize the employer into a Truework::Employer object' do
            expect(subject).to be_a(Truework::Employer)
          end

          context 'when the employer is missing' do
            context 'when the employee is missing' do
              before do
                report_json.delete(:employer)
              end

              it 'should raise an exception' do
                expect { subject }.to raise_error(Dry::Struct::Error, /:employer/)
              end
            end
          end

          it 'should convert the nested attributes correctly' do
            expect(subject.name).to eq('Truework Inc')
          end

          context 'nested attributes' do
            subject { report.employer.address }

            it 'should deserialize the address into a Truework::Address object' do
              expect(subject).to be_a(Truework::Address)
            end

            it 'should convert the nested attributes correctly' do
              expect(subject.line_one).to eq('15 Lucerne Street')
              expect(subject.line_two).to eq('Apt 2')
              expect(subject.city).to eq('San Francisco')
              expect(subject.state).to eq('CA')
              expect(subject.country).to eq('US')
              expect(subject.postal_code).to eq('94115')
            end
          end
        end
      end

      describe 'employee' do
        subject { report.employee }

        it 'should deserialize the employee into a Truework::Employee object' do
          expect(subject).to be_a(Truework::Employee)
        end

        context 'when the employee is missing' do
          before do
            report_json.delete(:employee)
          end

          it 'should raise an exception' do
            expect { subject }.to raise_error(Dry::Struct::Error, /:employee/)
          end
        end

        it 'should convert the nested attributes correctly' do
          expect(subject.first_name).to eq('First')
          expect(subject.last_name).to eq('Last')
          expect(subject.status).to eq('inactive')
          expect(subject.hired_date).to eq(Date.new(2017, 8, 8))
          expect(subject.end_of_employment).to eq(Date.new(2019, 8, 8))
        end

        context 'nested attributes' do
          describe 'earnings' do
            subject { report.employee.earnings[0] }

            it 'should deserialize the earnings into Truework::Earnings objects' do
              expect(subject).to be_a(Truework::Earnings)
            end

            it 'should convert the nested attributes correctly' do
              expect(subject.year).to eq(2019)
              expect(subject.base).to eq(BigDecimal('35000.00'))
              expect(subject.overtime).to eq(BigDecimal('200.00'))
              expect(subject.commission).to eq(BigDecimal('100.25'))
              expect(subject.bonus).to eq(BigDecimal('500.00'))
              expect(subject.total).to eq(BigDecimal('35800.25'))
            end
          end

          describe 'positions' do
            subject { report.employee.positions[0] }

            it 'should deserialize the positions into Truework::Position objects' do
              expect(subject).to be_a(Truework::Position)
            end

            it 'should convert the nested attributes correctly' do
              expect(subject.title).to eq('current title')
              expect(subject.start_date).to eq(Date.new(2018, 8, 8))
            end
          end

          describe 'salary' do
            subject { report.employee.salary }

            it 'should deserialize the salary into a Truework::Salary object' do
              expect(subject).to be_a(Truework::Salary)
            end

            it 'should convert the nested attributes correctly' do
              expect(subject.gross_pay).to eq(BigDecimal('30000.00'))
              expect(subject.pay_frequency).to eq('annually')
              expect(subject.hours_per_week).to eq(40)
            end
          end
        end
      end
    end

    describe '.retrieve' do
      let(:id) { 'AAAAAAAAQnIAAYd5YHFVOm8PNX2ecFbEjqV__upOKUE8YE_IK2GwSQTP' }
      let(:report) { Truework::Report.retrieve(id) }
      subject { report }

      context 'when successful' do
        before do
          stub_request(:get, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}#{id}/report/")
            .to_return(
              status: 200,
              body: fixture('report/report_1.json')
            )
        end

        it 'should return a VerificationRequest object' do
          expect(subject).to be_a(Truework::Report)
        end

        it 'should deserialize the response correctly' do
          expected = Truework::Report.new(
            created: DateTime.new(2008, 9, 15, 15, 53),
            current_as_of: DateTime.new(2008, 9, 15, 15, 53),
            verification_request: Truework::VerificationRequest.new(
              id: 'report_1',
              type: 'employment-income',
              created: DateTime.new(2008, 9, 14, 9)
            ),
            employer: Truework::Employer.new(
              name: 'Truework Inc',
              address: Truework::Address.new(
                line_one: '15 Lucerne Street',
                line_two: 'Apt 2',
                city: 'San Francisco',
                state: 'CA',
                country: 'US',
                postal_code: '94115'
              )
            ),
            employee: Truework::Employee.new(
              first_name: 'First',
              last_name: 'Last',
              status: 'inactive',
              hired_date: Date.new(2017, 8, 8),
              end_of_employment: Date.new(2019, 8, 8),
              social_security_number: '***-**-9999',
              earnings: [
                Truework::Earnings.new(
                  year: 2019,
                  base: '35000.00',
                  overtime: '200.00',
                  commission: '100.25',
                  bonus: '500.00',
                  total: '35800.25'
                ),
                Truework::Earnings.new(
                  year: 2018,
                  base: '30000.00',
                  overtime: '200.00',
                  commission: '100.25',
                  bonus: '500.00',
                  total: '30800.25'
                ),
                Truework::Earnings.new(
                  year: 2017,
                  base: '30000.00',
                  overtime: '200.00',
                  commission: '100.25',
                  bonus: '500.00',
                  total: '30800.25'
                )
              ],
              positions: [
                Truework::Position.new(
                  title: 'current title',
                  start_date: Date.new(2018, 8, 8)
                ),
                Truework::Position.new(
                  title: 'past title',
                  start_date: Date.new(2017, 8, 8),
                  end_date: Date.new(2019, 8, 8)
                )
              ],
              salary: Truework::Salary.new(
                gross_pay: '30000.00',
                pay_frequency: 'annually',
                hours_per_week: 40,
                months_per_year: 9.5
              )
            )
          )
          expect(subject).to eq(expected)
        end
      end

      context 'when not found' do
        let(:id) { 'bad_id' }
        before do
          stub_request(:get, "#{Truework.api_base}#{Truework::VerificationRequest.resource_path}#{id}/report/")
            .to_return(status: 404)
        end

        it 'raises an exception' do
          expect { subject }.to raise_error(Truework::NonExistentRecord)
        end
      end
    end
  end
end
