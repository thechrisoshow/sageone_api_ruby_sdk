module SageoneSdk
  class Client
    # Represents the contacts for the authenticated user's business.
    module Contacts
      # @return [object] Returns all contacts for the authenticated user's business.
      def contacts(options = {})
        get 'contacts', options
      end

      # @return [object] Returns all customers for the authenticated user's business.
      def customers(options = {})
        options['contact_type_id'] = 'CUSTOMER'
        contacts(options)
      end

      # @return [object] Returns all suppliers for the authenticated user's business.
      def vendors(options = {})
        contacts(options.merge(contact_type_id: 'VENDOR'))
      end

      # @return [object] Returns the contact with the given id.
      def contact(id, options = {})
        get "contacts/#{id}", options
      end

      # Creates a contact record with the data provided.
      # @example Create a new contact record
      #   @client.create_contact(name: 'ACME, Inc', type: 'CUSTOMER')
      # @param type [integer] The contact type
      # @param data [hash] The contact record information.
      # @param options [hash]
      def create_contact(name:, type:, **options)
        post 'contacts', contact: options.merge(name: name, contact_type_ids: [type])
      end

      # Creates a customer record with the data provided.
      # @example Create a new customer record
      #   @client.create_customer(name: 'ACME, Inc')
      # @param data [hash] The customer record information.
      # @param options [hash]
      def create_customer(name:, **options)
        create_contact(name: name, type: 'CUSTOMER', **options)
      end

      # Creates a customer record with the data provided.
      # @example Create a new vendor record
      #   @client.create_customer(name: 'My vendor')
      # @param data [hash] The vendor record information.
      # @param options [hash]
      def create_vendor(name:, **options)
        create_contact(name: name, type: 'VENDOR', **options)
      end

      # Updates the given contact record with the data provided.
      # @example Update contact record with id 1234
      #   @client.update_contact(1234, {"name" => "Updated contact name",
      #                                 "company_name" => "Updated company name"})
      # @param id [integer] The id of the contact record to update.
      # @param data [hash] The contact record information to update.
      def update_contact(id, data)
        put "contacts/#{id}", contact: data
      end

      # Deletes the given contact record.
      # @param id [integer] The id of the contact record to delete.
      def delete_contact(id)
        delete "contacts/#{id}"
      end
    end
  end
end
