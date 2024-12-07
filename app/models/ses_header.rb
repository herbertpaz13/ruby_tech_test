# frozen_string_literal: true

class SesHeader
  include ActiveModel::Model

  attr_accessor :name, :value

  def initialize(attributes = {})
    @name = attributes['name']
    @value = attributes['value']
  end
end
