require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'methods' do
    it 'customer_name' do
      customer = Customer.create!(first_name: 'Jeff', last_name: 'Bridges')
      invoice = customer.invoices.create!(status: 'in progress')
      expect(invoice.customer_name).to eq("#{customer.first_name} #{customer.last_name}")
    end

    it 'total_revenue' do
      customer = Customer.create!(first_name: 'Jeff', last_name: 'Bridges')
      invoice = customer.invoices.create!(status: 'in progress')
      merchant = Merchant.create!(name: "Stephen's Shady Store")
      item_toothpaste = merchant.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
      item_rock = merchant.items.create!(name: "Item Rock", description: "Decently cool rock", unit_price: 10000 )
      invoice.invoice_items.create!(item_id: item_toothpaste.id, 
                                    quantity: 1,
                                    unit_price: 6000,
                                    status: :pending)
      invoice.invoice_items.create!(item_id: item_rock.id,
                                    quantity: 3,
                                    unit_price: 12000,
                                    status: :shipped)
      expect(invoice.total_revenue).to eq(42000)
    end

    it '#incomplete' do
      @invoice1 = create(:invoice)
      create_list(:invoiceItem, 5, invoice_id: @invoice1.id, status: :shipped)
      @invoice2 = create(:invoice, created_at: Date.new(2019,7,18))
      create_list(:invoiceItem, 3, invoice_id: @invoice2.id, status: :pending)
      create_list(:invoiceItem, 3, invoice_id: @invoice2.id, status: :shipped)
      @invoice3 = create(:invoice, created_at: Date.new(2019,7,17))
      create_list(:invoiceItem, 5, invoice_id: @invoice3.id, status: :packaged)

      expect(Invoice.incomplete).to eq([@invoice3, @invoice2])
    end
  end

    describe 'discounted_revenue' do
      it 'returns the total discounted revenue for that invoice' do
          
        merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
        merchant_roger = Merchant.create!(name: "Roger's Fancy Store")
        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")
        
        item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
        item_lamp = merchant_stephen.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 250)
        
        invoice1 = customer1.invoices.create!(status: "completed")
        invoice2 = customer1.invoices.create!(status: "completed")
        
        invoice_itemA = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item_toothpaste.id, invoice_id: invoice1.id)
        invoice_itemB = InvoiceItem.create!(quantity:15, unit_price: 1500, status: "packaged", item_id: item_lamp.id, invoice_id: invoice1.id)
        
        bulk_discountA = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
        bulk_discountB = merchant_stephen.bulk_discounts.create(percentage_discount: 15, quantity_threshold: 15)
        bulk_discountC = merchant_stephen.bulk_discounts.create(percentage_discount: 50, quantity_threshold: 200)
        bulk_discountD = merchant_roger.bulk_discounts.create(percentage_discount: 18, quantity_threshold: 15)
      
        expect(invoice1.discounted_revenue).to eq(218000)
    end
  end
end
