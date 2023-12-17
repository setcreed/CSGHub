require 'rest_client'

module Starhub
  class Client
    class ApiError < StandardError; end

    include Singleton

    def get(path, options = {})
      request(:get, path, options)
    end

    def post(path, options = {})
      request(:post, path, options)
    end

    def put(path, options = {})
      request(:put, path, options)
    end

    private

    def build_request_url(path)
      base_url = Rails.application.credentials.starhub_api.send("#{Rails.env}").base_url
      base_url + path
    end

    def request(verb, path, options = {})
      headers = options[:headers] || {}
      headers['content-type'] ||= 'application/json'
      headers['Authorization'] ||= Rails.application.credentials.starhub_api.send("#{Rails.env}").token

      request = ::RestClient::Request.new(
        method: verb,
        url: build_request_url(path),
        headers: headers,
        payload: options[:body]
      )

      request.execute
    end
  end
end
