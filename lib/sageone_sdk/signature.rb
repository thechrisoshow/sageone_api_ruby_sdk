require 'base64'
require 'openssl'
require 'cgi'
require 'securerandom'

module SageoneSdk
  # Signature
  class Signature
    attr_reader :http_method, :nonce

    # Constructor
    def initialize(http_method, url, request_body, secret, token, business_guid)
      @http_method = http_method.to_s.upcase
      @url = URI(url)
      @request_body = request_body.to_s
      @secret = secret
      @token = token
      @business_guid = business_guid
    end

    # Set the base URL
    def base_url
      @url.to_s.split('?').first
    end

    # Generate Nonce
    def nonce
      @nonce ||= SecureRandom.hex
    end

    # Generate the request params from the request query and body params
    def request_params
      params = get_params_hash(@url.query)
      params.merge!('body' => percent_encode(Base64.strict_encode64(@request_body)))
      params.sort.map { |key, value| "#{key}=#{value}" }.join('&')
    end

    # Generate the base signature string
    def signature_base_string
      [
        @http_method.dup,
        percent_encode(base_url),
        percent_encode(request_params),
        percent_encode(nonce.to_s),
        percent_encode(@business_guid)
      ].join('&')
    end

    # Generate the signing key
    def signing_key
      [percent_encode(@secret), percent_encode(@token)].join('&')
    end

    # Generates the signature
    def to_s
      Base64.encode64(
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), signing_key, signature_base_string)
      )
    end

    private

    # Generates a hash from a params string
    def get_params_hash(params)
      params_hash = {}

      if !params.nil? and !params.empty?
        params = percent_decode(params)
        params.split('&').each do |param|
          param_pair = param.split('=')
          params_hash[percent_encode(param_pair[0])] = percent_encode(param_pair[1])
        end
      end

      params_hash
    end

    # Percent encodes special characters in a string
    def percent_encode(str)
      # Replaced deprecated URI.escape with CGI.escape
      # CGI.escape replaces spaces with "+", so we also need to substitute them with "%20"
      CGI.escape(str).gsub("+", "%20")
    end

    def percent_decode(str)
      CGI.unescape(str).gsub("%20", "+")
    end
  end
end
