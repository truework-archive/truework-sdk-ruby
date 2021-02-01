# frozen_string_literal: true

module Truework
  class Respondent < APIResource
    attribute? :full_name, Types::String
    attribute? :title, Types::String
  end
end
