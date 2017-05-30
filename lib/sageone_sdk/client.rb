require 'sawyer'
require 'faraday_middleware'
require 'sageone_sdk/authentication'
require 'sageone_sdk/middleware'
require 'sageone_sdk/version'
require 'sageone_sdk/client/account_types'
require 'sageone_sdk/client/bank_accounts'
require 'sageone_sdk/client/coa_accounts'
require 'sageone_sdk/client/contacts'
require 'sageone_sdk/client/expenditures'
require 'sageone_sdk/client/expense_methods'
require 'sageone_sdk/client/expense_types'
require 'sageone_sdk/client/financial_settings'
require 'sageone_sdk/client/income_methods'
require 'sageone_sdk/client/income_types'
require 'sageone_sdk/client/incomes'
require 'sageone_sdk/client/journals'
require 'sageone_sdk/client/ledger_account_types'
require 'sageone_sdk/client/ledger_accounts'
require 'sageone_sdk/client/payment_statuses'
require 'sageone_sdk/client/period_types'
require 'sageone_sdk/client/purchase_invoices'
require 'sageone_sdk/client/products'
require 'sageone_sdk/client/sales_estimates'
require 'sageone_sdk/client/sales_invoices'
require 'sageone_sdk/client/services'
require 'sageone_sdk/client/tax_rates'
require 'sageone_sdk/client/transactions'

module SageoneSdk
  class Client
    API_ENDPOINTS = {
      'ca' => 'https://api.columbus.sage.com/ca/sageone',
      'de' => 'https://api.columbus.sage.com/de/sageone',
      'es' => 'https://api.columbus.sage.com/fr/sageone',
      'fr' => 'https://api.columbus.sage.com/fr/sageone',
      'ie' => 'https://api.columbus.sage.com/uki/sageone',
      'uk' => 'https://api.columbus.sage.com/uki/sageone',
      'us' => 'https://api.columbus.sage.com/us/sageone'
    }.freeze

    USER_AGENT = "sageone_sdk Ruby Gem #{SageoneSdk::VERSION}".freeze

    include SageoneSdk::Authentication
    include SageoneSdk::Client::AccountTypes
    include SageoneSdk::Client::BankAccounts
    include SageoneSdk::Client::CoaAccounts
    include SageoneSdk::Client::Contacts
    include SageoneSdk::Client::Expenditures
    include SageoneSdk::Client::ExpenseMethods
    include SageoneSdk::Client::ExpenseTypes
    include SageoneSdk::Client::FinancialSettings
    include SageoneSdk::Client::IncomeMethods
    include SageoneSdk::Client::IncomeTypes
    include SageoneSdk::Client::Incomes
    include SageoneSdk::Client::Journals
    include SageoneSdk::Client::LedgerAccountTypes
    include SageoneSdk::Client::LedgerAccounts
    include SageoneSdk::Client::PaymentStatuses
    include SageoneSdk::Client::PeriodTypes
    include SageoneSdk::Client::PurchaseInvoices
    include SageoneSdk::Client::Products
    include SageoneSdk::Client::SalesEstimates
    include SageoneSdk::Client::SalesInvoices
    include SageoneSdk::Client::Services
    include SageoneSdk::Client::TaxRates
    include SageoneSdk::Client::Transactions

    # Valid options are:
    # :access_token, :refresh_token, :signing_secret, :redirect_uri, :client_id, :client_secret,
    # :resource_owner_id, :api_subscription_id, :country
    def initialize(options = {})
      @options = options
    end

    # Last Response
    def last_response
      @last_response if defined? @last_response
    end

    # Get Request
    # @param [String] path the request path
    # @param [Hash] data the request data
    def get(path, data = nil)
      request(:get, path, data)
    end

    # Post Request
    # @param [String] path the request path
    # @param [Hash] data the request data
    def post(path, data = {})
      request(:post, path, data.to_json)
    end

    # Put Request
    # @param [String] path the request path
    # @param [Hash] data the request data
    def put(path, data = {})
      request(:put, path, data.to_json)
    end

    # Delete Request
    # @param [String] path the request path
    # @param [Hash] data the request data
    def delete(path, data = {})
      request(:delete, path, data)
    end

    # Request
    # @param [String] method the request method
    # @param [String] path the request path
    # @param [Hash] data the request data
    # @param [Hash] options Options for the request
    def request(method, path, data, options = {})
      path = File.join('accounts', 'v3', path)
      @last_response = response = agent.public_send(
        method, URI::Parser.new.escape(path.to_s), data, options
      )
      response.body
    end

    # Agent
    def agent
      @agent ||= Faraday.new(api_endpoint, faraday_options) do |builder|
        builder.request :url_encoded
        builder.headers['Accept'] = 'application/json'
        builder.headers['User-Agent'] = USER_AGENT
        builder.headers['Content-Type'] = 'application/json'
        builder.headers['ocp-apim-subscription-key'] = @options[:api_subscription_id]
        builder.headers['X-Site'] = @options[:resource_owner_id]

        unless @options[:access_token].nil?
          builder.authorization 'Bearer', @options[:access_token]
        end

        builder.use(
          SageoneSdk::Middleware::Signature,
          @options[:access_token],
          @options[:signing_secret],
          @options[:resource_owner_id]
        )

        builder.adapter Faraday.default_adapter
        builder.use SageoneSdk::Middleware::SDataParser
      end
    end

    private

    def api_endpoint
      API_ENDPOINTS[@options[:country]]
    end

    def faraday_options
      {}
    end
  end
end
