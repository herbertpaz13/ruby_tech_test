# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailParserController, type: :controller do
  describe 'POST #process_email' do
    let(:attach_email_path) { Rails.root.join('spec/fixtures/files/attach-json.eml') }
    let(:url_email_path) { Rails.root.join('spec/fixtures/files/url-json.eml') }
    let(:website_email_path) { Rails.root.join('spec/fixtures/files/website-json.eml') }
    let(:no_json_email_path) { Rails.root.join('spec/fixtures/files/no-json.eml') }

    context 'when email path is not provided' do
      it 'returns bad request status' do
        post :process_email
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq('error' => 'No email path provided')
      end
    end

    context 'when JSON is found in the email' do
      it 'Found as an attachment and returns json data and status ok' do
        post :process_email, params: { email_path: attach_email_path.to_s }

        expect(response).to have_http_status(:ok)
        expect { response.parsed_body }.not_to raise_error
      end

      it 'Found as a url and returns json data and status ok' do
        post :process_email, params: { email_path: url_email_path.to_s }

        expect(response).to have_http_status(:ok)
        expect { response.parsed_body }.not_to raise_error
      end

      it 'Found as a website url and returns json data and status ok' do
        post :process_email, params: { email_path: website_email_path.to_s }

        expect(response).to have_http_status(:ok)
        expect { response.parsed_body }.not_to raise_error
      end
    end

    context 'when no JSON is found in the email' do
      it 'returns unprocessable entity status' do
        post :process_email, params: { email_path: no_json_email_path.to_s }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to eq('error' => 'No JSON found in the email')
      end
    end

    context 'when an unexpected error occurs' do
      it 'returns internal server error status' do
        allow(Mail).to receive(:read).and_raise(StandardError.new('Unexpected error'))

        post :process_email, params: { email_path: attach_email_path.to_s }

        expect(response).to have_http_status(:internal_server_error)
        expect(response.parsed_body).to eq('error' => 'An unexpected error occurred: Unexpected error')
      end
    end
  end
end
