require 'sageone_sdk/client'
# SageoneSdk
module SageoneSdk
  autoload :SDataResponse, 'sageone_sdk/sdata_response'
  class << self
    # Returns an instance of SageoneSdk::Client
    def client
      @client = SageoneSdk::Client.new unless defined?(@client)
      @client
    end
  end
end
