module SageoneSdk
  # SData error response
  class SDataErrorResponse < SDataResponse
    attr_reader :data

    def initialize(data = {})
      super(data)
    end

    # Full Messages
    def full_messages
      diagnoses.map do |x|
        "#{x["$source"].humanize}: #{x["$message"]}"
      end
    end

    # Error?
    # @return Boolean
    def error?
      true
    end

    # Handle method missing
    def method_missing(method, *args, &block)
      if diagnoses.respond_to?(method)
        diagnoses.send(method, *args)
      else
        super
      end
    end
  end
end
