# frozen_string_literal: true

class Record
  include ActiveModel::Model

  attr_accessor :event_version, :ses, :event_source

  delegate :receipt, to: :ses
  delegate :mail, to: :ses

  # Creates Record instances from a JSON data hash containing email event records
  #
  # @param json_data [Hash] The JSON data containing email event records
  # @return [Array<Record>] An array of Record instances parsed from the JSON data
  def self.from_json(json_data)
    records = json_data['Records']
    records.map do |record|
      new(
        event_version: record['eventVersion'],
        event_source: record['eventSource'],
        ses: Ses.new(record['ses'])
      )
    end
  end

  # Checks if the record passed spam detection
  #
  # @return [Boolean] true if the record passed spam verdict, false otherwise
  def spam
    verdict_pass?(receipt.spam_verdict)
  end

  # Checks if the record passed virus detection
  #
  # @return [Boolean] true if the record passed virus verdict, false otherwise
  def virus
    verdict_pass?(receipt.virus_verdict)
  end

  # Checks if the record passed DNS-related verifications (SPF, DKIM, DMARC)
  #
  # @return [Boolean] true if all DNS-related verdicts pass, false otherwise
  def dns
    %w[spf_verdict dkim_verdict dmarc_verdict].all? { |verdict| verdict_pass?(receipt.public_send(verdict)) }
  end

  # Retrieves the month of the record based on its timestamp
  #
  # @return [String] The full name of the month (e.g., 'January', 'February')
  def month
    Time.zone.parse(mail.timestamp).strftime('%B')
  end

  # Checks if email processing was delayed
  #
  # @return [Boolean] true if processing took more than 1 second, false otherwise
  def delayed
    receipt.processing_time_millis.to_i > 1000
  end

  # Extracts the sender's username
  #
  # @return [String] The username part of the sender's email address
  def sender
    mail.source.split('@').first
  end

  # Extracts the receivers' usernames
  #
  # @return [Array<String>] An array of usernames from destination email addresses
  def receiver
    mail.destination.map { |mail| mail.split('@').first }
  end

  private

  # Checks if a given verdict has a 'PASS' status
  #
  # @param verdict [Object] The verdict object to check
  # @return [Boolean] true if the verdict status is 'PASS', false otherwise
  def verdict_pass?(verdict)
    verdict.status == 'PASS'
  end
end
