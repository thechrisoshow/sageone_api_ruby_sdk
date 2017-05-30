module SageoneSdk
  class Client
    # Represents the sales estimates for the authenticated user's business.
    module SalesEstimates
      # @return [object] Returns all sales estimates for the authenticated user's business.
      def sales_estimates(options = {})
        get 'sales_estimates', options
      end

      # @return [object] Returns the sales estimate with the given id.
      def sales_estimate(id, options = {})
        get "sales_estimates/#{id}", options
      end

      # Creates a sales estimate with the data provided.
      # @example Create a new sales estimate
      #   @client.create_sales_estimate(
      #     contact_id: '237',
      #     date: '2016-01-01',
      #     expiry_date: '2016-01-31',
      #     shipping_net_amount: 0,
      #     estimate_lines: []
      #   )
      # @param data [hash] The sales estimate information.
      # @param options [hash]
      def create_sales_estimate(contact_id:, date:, expiry_date:, shipping_net_amount:,
                                estimate_lines: [], **options)
        post 'sales_estimates',
             sales_estimate: options.merge(
               contact_id: contact_id,
               date: date,
               expiry_date: expiry_date,
               shipping_net_amount: shipping_net_amount,
               estimate_lines: estimate_lines
             )
      end

      # Updates the given sales estimate with the data provided.
      # @example Update a sales estimate due_date
      #   @client.update_sales_estimate(1243, {"due_date" => "2016-01-31"})
      # @param id [integer] The id of the sales estimate to update.
      # @param data [hash] The sales estimate information to update.
      # @param options [hash]
      def update_sales_estimate(id, data, _options = {})
        put "sales_estimates/#{id}", sales_estimate: data
      end

      # Deletes the sales estimate with the given id.
      # @param id [integer] The id of the sales estimate to delete.
      # @param options [hash]
      def delete_sales_estimate(id, _options = {})
        delete "sales_estimates/#{id}"
      end
    end
  end
end
