# frozen_string_literal: true

class SesCommonHeader
  include ActiveModel::Model

  attr_accessor :return_path, :from, :date, :to, :message_id, :subject

  def initialize(attributes = {})
    @return_path = attributes['returnPath'] if attributes
    @from = attributes['from'] if attributes
    @date = attributes['date'] if attributes
    @to = attributes['to'] if attributes
    @message_id = attributes['messageId'] if attributes
    @subject = attributes['subject'] if attributes
  end
end
