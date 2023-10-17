# frozen_string_literal: true

require 'net/http'
require 'json'

class Request
  def self.get(url, authorization = nil)
    uri = URI.parse(clean_url(url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = use_ssl?(url)
    request = Net::HTTP::Get.new(uri.request_uri)
    add_headers(request, authorization)
    JSON.parse(http.request(request).body)
  end

  def self.post(url, authorization, body)
    uri = URI.parse(clean_url(url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = use_ssl?(url)

    request = Net::HTTP::Post.new(uri.request_uri, { 'Content-Type' => 'application/json' })
    request.body = body.to_json

    add_headers(request, authorization)

    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.add_headers(request, authorization)
    request['Authorization'] = authorization
    request['Accept'] = 'application/json'
  end

  def self.clean_url(url)
    url.gsub(' ', '%20')
  end

  def self.use_ssl?(url)
    url.match?(/^https/)
  end
end
