# frozen_string_literal: true

require 'truework/resources/earnings'
require 'truework/resources/position'
require 'truework/resources/salary'

module Truework
  class Employee < APIResource
    attribute :first_name, Types::String
    attribute :last_name, Types::String
    attribute :status, Types::String
    attribute? :hired_date, Types::JSON::Date
    attribute? :termination_date, Types::JSON::Date
    attribute :social_security_number, Types::String
    attribute? :earnings, Types::Array.of(Earnings)
    attribute? :positions, Types::Array.of(Position)
    attribute? :salary, Salary
  end
end
