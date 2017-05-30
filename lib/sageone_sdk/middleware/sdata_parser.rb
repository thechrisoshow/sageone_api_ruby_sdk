require 'sageone_sdk/signature'
require 'sageone_sdk/sdata_error_response'
require 'sageone_sdk/sdata_response'
require 'json'
require 'hashie/mash'

module SageoneSdk
  module Middleware
    # Sdata parser
    class SDataParser < Faraday::Middleware
      # Call
      def call(environment)
        @app.call(environment).on_complete do |env|
          element = ::JSON.parse(env[:body]) unless env[:body].strip.blank?
          env[:body] = if element.respond_to?(:each_pair)
                         if env.success?
                           SageoneSdk::SDataResponse.new(element)
                         else
                           SageoneSdk::SDataErrorResponse.new(element)
                         end
                       else
                         element.map { |x| Hashie::Mash.new(x) }
                       end
        end
      end
    end
  end
end
