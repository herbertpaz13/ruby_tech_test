# frozen_string_literal: true

class EmailParserController < ApplicationController
  def process_email
    return render json: { error: 'No email path provided' }, status: :bad_request unless params[:email_path]

    email = Mail.read(params[:email_path])

    json_data = EmailJsonParserService.extract_json_from_email(email)

    if json_data
      render json: JSON.parse(json_data), status: :ok
    else
      render json: { error: 'No JSON found in the email' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end
end
