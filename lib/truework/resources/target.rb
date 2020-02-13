# frozen_string_literal: true

module Truework
  class Target < APIResource
    attribute :company, Company
    attribute :first_name, Types::String
    attribute :last_name, Types::String
    attribute :contact_email, Types::String
  end
end
