require 'sageone_sdk/signature'

module SageoneSdk
  module Middleware
    # Signature
    class Signature < Faraday::Middleware
      def initialize(app, access_token, signing_secret, business_guid)
        super(app)

        @access_token = access_token
        @signing_secret = signing_secret
        @business_guid = business_guid
      end

      # Call
      def call(env)
        signature = SageoneSdk::Signature.new(
          env.method, env.url, env.body, @signing_secret, @access_token, @business_guid
        )

        env[:request_headers]['X-Nonce'] = signature.nonce
        env[:request_headers]['X-Signature'] = signature.to_s

        @app.call(env)
      end
    end
  end
end
