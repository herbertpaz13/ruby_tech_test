# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Record, type: :model do
  subject(:record) do
    described_class.from_json(json_data).first
  end

  let(:json_data) do
    {
      'Records' => [
        {
          'eventVersion' => '1.0',
          'ses' => {
            'receipt' => {
              'timestamp' => '2015-09-11T20:32:33.936Z',
              processingTimeMillis: 222,
              'spamVerdict' => { 'status' => 'PASS' },
              'virusVerdict' => { 'status' => 'PASS' },
              'spfVerdict' => { 'status' => 'PASS' },
              'dkimVerdict' => { 'status' => 'PASS' },
              'dmarcVerdict' => { 'status' => 'PASS' }
            },
            'mail' => {
              'timestamp' => '2015-12-11T20:32:33.936Z',
              'source' => '61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com',
              'destination' => ['recipient@example.com']
            }
          },
          'eventSource' => 'aws:ses'
        }
      ]
    }
  end

  describe '#spam' do
    it 'check the spam method on the record' do
      expect(record.spam).to be(true)
    end
  end

  describe '#virus' do
    it 'check the virus method on the record' do
      expect(record.virus).to be(true)
    end
  end

  describe '#dns' do
    it 'check the dns method on the record' do
      expect(record.virus).to be(true)
    end
  end

  describe '#month' do
    it 'check the month method on the record' do
      expect(record.month).to eq('December')
    end
  end

  describe '#delayed' do
    it 'check the delayed method on the record' do
      expect(record.delayed).to be(false)
    end
  end

  describe '#sender' do
    it 'check the sender method on the record' do
      expect(record.sender).to eq('61967230-7A45-4A9D-BEC9-87CBCF2211C9')
    end
  end

  describe '#receiver' do
    it 'check the receiver method on the record' do
      expect(record.receiver).to eq(['recipient'])
    end
  end
end
