# frozen_string_literal: true

require 'truework/resources/employee'
require 'truework/resources/employer'
require 'truework/resources/respondent'
require 'truework/resources/verification_request'

module Truework
  class Report < APIResource
    extend APIOperations::Retrieve

    attribute :created, Types::JSON::DateTime
    attribute :current_as_of, Types::JSON::DateTime
    attribute :verification_request, VerificationRequest
    attribute :employer, Employer
    attribute :employee, Employee
    attribute? :additional_notes, Types::String
    attribute? :respondent, Respondent

    def self.instance_url(verification_request_id)
      "/verification-requests/#{verification_request_id}/report/"
    end
  end
end
