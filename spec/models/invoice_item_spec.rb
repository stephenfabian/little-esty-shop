require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'methods' do
    it 'item name' do
      merchant = Merchant.create!(name: "Stephen's Shady Store")
      item = merchant.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
      customer = Customer.create!(first_name: 'Jeff', last_name: 'Bridges')
      invoice = customer.invoices.create!(status: 'in progress')
      invoice_item = invoice.invoice_items.create!(item_id: item.id, 
                                         quantity: 1,
                                         unit_price: 6000,
                                         status: :pending)

      expect(invoice_item.item_name).to eq(item.name)
    end
  end

  describe 'discount_to_use' do
    it 'returns the discount percantage to use for a particular invoice item, in decimal form (20% -> 0.2)' do

        merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
        merchant_roger = Merchant.create!(name: "Roger's Fancy Store")
        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")

        item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
        item_lamp = merchant_stephen.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 250)

        invoice1 = customer1.invoices.create!(status: "completed")
        invoice2 = customer1.invoices.create!(status: "completed")
    #both invoices_items should get the 20% discount, since 20% is the highest discount, and they are both over the 10 unit threshold
        invoice_itemA = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item_toothpaste.id, invoice_id: invoice1.id)
        invoice_itemB = InvoiceItem.create!(quantity:15, unit_price: 1500, status: "packaged", item_id: item_lamp.id, invoice_id: invoice1.id)

        bulk_discountA = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
        bulk_discountB = merchant_stephen.bulk_discounts.create(percentage_discount: 15, quantity_threshold: 15)
        bulk_discountC = merchant_stephen.bulk_discounts.create(percentage_discount: 50, quantity_threshold: 200)
        bulk_discountD = merchant_roger.bulk_discounts.create(percentage_discount: 18, quantity_threshold: 15)

        # expect(invoice_itemA.discount_to_use).to eq(0.2)
        expect(invoice_itemA.discount_to_use).to eq(bulk_discountA)
    end 
  end

  describe 'invoice_item_discounted_revenue' do
    it 'returns the discounted revenue for a particular invoice_item' do
   
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
    
    
      expect(invoice_itemA.invoice_item_discounted_revenue).to eq(200000.0)
    end
    

    it 'returns total revenue if there are not discounts available' do
      merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
      merchant_roger = Merchant.create!(name: "Roger's Fancy Store")
      customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")
      
      item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
      item_lamp = merchant_stephen.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 250)
      
      invoice1 = customer1.invoices.create!(status: "completed")
      invoice2 = customer1.invoices.create!(status: "completed")
      
      invoice_itemA = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item_toothpaste.id, invoice_id: invoice1.id)
      invoice_itemB = InvoiceItem.create!(quantity:15, unit_price: 1500, status: "packaged", item_id: item_lamp.id, invoice_id: invoice1.id)
      
      bulk_discountA = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 200)
      bulk_discountB = merchant_stephen.bulk_discounts.create(percentage_discount: 15, quantity_threshold: 200)
      bulk_discountC = merchant_stephen.bulk_discounts.create(percentage_discount: 50, quantity_threshold: 200)
      bulk_discountD = merchant_roger.bulk_discounts.create(percentage_discount: 18, quantity_threshold: 15)

      expect(invoice_itemA.invoice_item_discounted_revenue).to eq(250000)
    end


  end
end
