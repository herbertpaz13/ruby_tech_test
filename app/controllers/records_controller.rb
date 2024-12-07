# frozen_string_literal: true

class RecordsController < ApplicationController
  def process_event
    begin
      json_data = JSON.parse(request.body.read)
    rescue JSON::ParserError
      return render json: { error: 'Invalid JSON format' }, status: :unprocessable_entity
    end

    @records = Record.from_json(json_data)
  rescue StandardError => e
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end
end
