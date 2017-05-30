require 'hashie/mash'

module SageoneSdk
  # SData response
  class SDataResponse
    attr_reader :data

    def initialize(data = {})
      @data = Hashie::Mash.new format_keys(data)
    end

    # Error?
    # @return Boolean
    def error?
      false
    end

    # Find By
    # @param conditions
    def find_by(conditions)
      resources.detect do |resource|
        @skip = false
        conditions.each do |field, value|
          unless resource.public_send(field) == value
            @skip = true
            break
          end
        end

        !@skip
      end
    end

    # Respond to missing?
    # @return Boolean
    def respond_to_missing?(method, include_private = false)
      @data.respond_to?(method, include_private)
    end

    # Handle method missing
    def method_missing(method, *args, &block)
      if @data.respond_to?(method)
        @data.send(method, *args)
      else
        super
      end
    end

    private

    # Remove $ from json keys and underscore methods for ruby-likeness
    def format_keys(hash)
      hash.keys.each { |k| hash[k.delete('$').underscore] = hash.delete(k) }
      hash
    end
  end
end
