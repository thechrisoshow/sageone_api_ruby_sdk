module SageoneSdk
  class Client
    # Represents the chart of accounts. This is a list
    # of all of the accounts used by your business. It defines the structure
    # of your income, expenditure, assets, liabilities and capital when
    # running your management reports.
    module CoaAccounts
      # @return [object] Returns all accounts.
      def coa_accounts(options = {})
        get 'coa_accounts', options
      end
    end
  end
end
