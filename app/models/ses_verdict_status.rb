# frozen_string_literal: true

class SesVerdictStatus
  include ActiveModel::Model

  attr_accessor :status

  def initialize(attributes = {})
    @status = attributes['status']
  end
end
