# frozen_string_literal: true

require 'truework/resources/document'
require 'truework/resources/target'
require 'truework/resources/turnaround_time'

module Truework
  class VerificationRequest < APIResource
    extend APIOperations::Create
    extend APIOperations::Cancel
    extend APIOperations::List
    extend APIOperations::Retrieve

    attribute :id, Types::String
    attribute? :type, Types::String
    attribute :created, Types::Params::DateTime
    attribute? :state, Types::String
    attribute? :price, Price
    attribute? :loan_id, Types::String
    attribute? :turnaround_time, TurnaroundTime
    attribute? :cancellation_details, Types::String
    attribute? :cancellation_reason, Types::String
    attribute? :permissible_purpose, Types::String
    attribute? :target, Target
    attribute? :documents, Types::Array.of(Document)

    def self.resource_path
      '/verification-requests/'
    end

    def self.cancel(id, cancellation_reason, details)
      super(id, { 'cancellation_reason' => cancellation_reason, 'cancellation_details' => details })
    end
  end
end
