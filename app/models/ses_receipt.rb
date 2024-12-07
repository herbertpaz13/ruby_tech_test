# frozen_string_literal: true

class SesReceipt
  include ActiveModel::Model

  attr_accessor :timestamp, :processing_time_millis, :recipients, :spam_verdict, :virus_verdict, :spf_verdict,
                :dkim_verdict, :dmarc_verdict, :dmarc_policy, :action

  def initialize(attributes = {})
    @timestamp = attributes['timestamp']
    @processing_time_millis = attributes['processingTimeMillis']
    @recipients = attributes['recipients']
    @spam_verdict = SesVerdictStatus.new(attributes['spamVerdict'])
    @virus_verdict = SesVerdictStatus.new(attributes['virusVerdict'])
    @spf_verdict = SesVerdictStatus.new(attributes['spfVerdict'])
    @dkim_verdict = SesVerdictStatus.new(attributes['dkimVerdict'])
    @dmarc_verdict = SesVerdictStatus.new(attributes['dmarcVerdict'])
    @dmarc_policy = attributes['dmarcPolicy']
    @action = SesAction.new(attributes['action'])
  end
end
