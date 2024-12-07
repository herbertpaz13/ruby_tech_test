# frozen_string_literal: true

class SesMail
  include ActiveModel::Model

  attr_accessor :timestamp, :source, :message_id, :destination, :headers_truncated, :headers, :common_headers

  def initialize(attributes = {})
    @timestamp = attributes['timestamp']
    @source = attributes['source']
    @message_id = attributes['messageId']
    @destination = attributes['destination']
    @headers_truncated = attributes['headersTruncated']
    @headers = attributes['headers']&.map { |h| SesHeader.new(h) }
    @common_headers = SesCommonHeader.new(attributes['commonHeaders'])
  end
end
