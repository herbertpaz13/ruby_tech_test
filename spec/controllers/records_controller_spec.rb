# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  describe 'POST #process_event' do
    let(:invalid_json) { 'invalid_json_format' }
    let(:valid_json) do
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
                'timestamp' => '2015-09-11T20:32:33.936Z',
                'source' => '61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com',
                'destination' => ['recipient@example.com']
              }
            },
            'eventSource' => 'aws:ses'
          }
        ]
      }
    end

    context 'when the JSON body is valid' do
      it 'parses JSON data and returns records' do
        post :process_event, params: valid_json, as: :json

        expect(response).to have_http_status(:ok)
        expect(assigns(:records)).not_to be_empty
      end
    end

    context 'when the JSON body is invalid' do
      it 'returns a 422 Unprocessable Entity status with an error message' do
        post :process_event, body: invalid_json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq('error' => 'Invalid JSON format')
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(Record).to receive(:from_json).and_raise(StandardError, 'Something went wrong')
      end

      it 'returns a 500 Internal Server Error status with an error message' do
        post :process_event, params: valid_json, as: :json

        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body).to eq('error' => 'An unexpected error occurred: Something went wrong')
      end
    end
  end
end
