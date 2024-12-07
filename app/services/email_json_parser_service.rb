# frozen_string_literal: true

# A service class for extracting JSON data from emails and URLs
#
# This class provides methods to:
# - Extract JSON from email attachments
# - Extract JSON from URLs within email bodies
# - Fetch JSON from web resources with multiple fallback strategies
#
# @note Uses external libraries: net/http, nokogiri, json
class EmailJsonParserService
  require 'net/http'

  class << self
    # Extracts JSON data from an email by searching attachments and body URLs
    #
    # @param email [Mail::Message] The email to search for JSON
    # @return [String, nil] JSON data if found, nil otherwise
    def extract_json_from_email(email)
      # First, check email attachments for JSON
      email.attachments.each do |attachment|
        return attachment.body.decoded if attachment.content_type.include?('json')
      end

      # If no attachment, search for URLs in email body
      email.body.to_s.scan(%r{https?://[^\s]+}).each do |url|
        json_data = extract_json_from_url(url)
        return json_data if json_data
      end

      # Return nil if no JSON found
      nil
    end

    # Attempts to extract JSON from a given URL using multiple strategies
    #
    # @param url [String] The URL to fetch JSON from
    # @return [String, nil] JSON data if found, nil otherwise
    def extract_json_from_url(url)
      # First, try to fetch JSON directly
      json_data = try_fetch_json(url)
      return json_data if json_data

      # If not found, try to fetch JSON from HTML
      html_data = try_fetch_json_from_html(url)
      return html_data if html_data

      # Return nil if no JSON found
      nil
    end

    private

    # Attempts to fetch and validate JSON from a URL
    #
    # @param url [String] The URL to fetch JSON from
    # @return [String, nil] JSON data if valid, nil otherwise
    def try_fetch_json(url)
      response = fetch_response(url)

      response.body if response && valid_json?(response.body)
    end

    # Attempts to find JSON by parsing links in an HTML page
    #
    # @param url [String] The HTML page URL to search
    # @return [String, nil] JSON data if found in page links, nil otherwise
    def try_fetch_json_from_html(url)
      response = fetch_response(url)
      return nil unless valid_html_response?(response)

      html_doc = Nokogiri::HTML(response.body)
      html_doc.css('a').each do |link|
        next_url = link['href']
        next_url = URI.join(url, next_url).to_s if next_url.start_with?('/')
        json_data = try_fetch_json(next_url) if next_url
        return json_data if json_data
      end
    end

    # Validates if the given string is valid JSON
    #
    # @param json_data [String] The string to validate as JSON
    # @return [Boolean] true if valid JSON, false otherwise
    def valid_json?(json_data)
      JSON.parse(json_data)
      true
    rescue JSON::ParserError
      false
    end

    # Fetches a response from a given URL
    #
    # @param url [String] The URL to fetch
    # @return [Net::HTTPResponse, nil] HTTP response or nil if fetch fails
    def fetch_response(url)
      uri = URI.parse(url)
      Net::HTTP.get_response(uri)
    rescue StandardError
      nil
    end

    # Checks if a response is a valid HTML response
    #
    # @param response [Net::HTTPResponse] The HTTP response to validate
    # @return [Boolean] true if response is HTML, false otherwise
    def valid_html_response?(response)
      response && response['content-type']&.include?('text/html')
    end
  end
end
