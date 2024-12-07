# frozen_string_literal: true

class Ses
  include ActiveModel::Model

  attr_accessor :receipt, :mail

  def initialize(attributes = {})
    @receipt = SesReceipt.new(attributes['receipt']) if attributes['receipt']
    @mail = SesMail.new(attributes['mail']) if attributes['mail']
  end
end
