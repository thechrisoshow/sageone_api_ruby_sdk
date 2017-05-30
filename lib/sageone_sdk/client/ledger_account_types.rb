module SageoneSdk
  class Client
    # Represents ledger account types for the authenticated user's business.
    module LedgerAccountTypes
      # @return [object] Returns all ledger account types for the authenticated user's business.
      def ledger_account_types(options = {})
        get 'ledger_account_types', options
      end

      # @return [object] Returns the ledger account with the given id.
      def ledger_account_type(id, options = {})
        get "ledger_account_types/#{id}", options
      end
    end
  end
end
