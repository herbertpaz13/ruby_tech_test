# frozen_string_literal: true

class SesAction
  include ActiveModel::Model

  attr_accessor :type, :topic_arn

  def initialize(attributes = {})
    @type = attributes['type'] if attributes
    @topic_arn = attributes['topicArn'] if attributes
  end
end
