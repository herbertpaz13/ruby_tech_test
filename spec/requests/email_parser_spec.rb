# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Email Parser', type: :request do
  path '/email_parser/process_email' do
    post 'Processes email to extract JSON' do
      tags 'Email Parser'
      consumes 'application/json'

      parameter name: :email_path,
                in: :query,
                schema: {
                  type: :string,
                  enum: [
                    'spec/fixtures/files/attach-json.eml',
                    'spec/fixtures/files/url-json.eml',
                    'spec/fixtures/files/website-json.eml',
                    'spec/fixtures/files/no-json.eml'
                  ]
                },
                description: 'Path to the email file',
                required: true

      response '200', 'JSON data found in email' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   name: { type: :string },
                   language: { type: :string },
                   id: { type: :string },
                   bio: { type: :string },
                   version: { type: :number }
                 },
                 required: %w[name language id bio version]
               }

        let(:email_path) { 'spec/fixtures/files/url-json.eml' }

        run_test!
      end
    end
  end
end
