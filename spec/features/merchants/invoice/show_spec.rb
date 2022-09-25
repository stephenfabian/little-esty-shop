require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  # before :each do
  #   names_array = {'gjcarew' => 22, 'stephenfabian' => 25, 'Rileybmcc' => 22, 'KevinT001' => 11}
  #   allow(GithubFacade).to receive(:commits).and_return(names_array)

  #   pull_requests_count = 3
  #   allow(GithubFacade).to receive(:pull_requests).and_return(pull_requests_count)
  # end
  describe 'When I visit my merchants invoice show page(/merchants/merchant_id/invoices/invoice_id)' do
    describe 'Then I see information related to that invoice' do 
      it 'Invoice id, status, created_at date(Monday, July 18, 2019), Customer first/last name' do

        steph_merchant = Merchant.create!(name: "Stephen's shop")
        kev_merchant = Merchant.create!(name: "Kevin's shop")

        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")

        item1 = Item.create!(name: "Climbing Chalk", description: "Purest powder on the market", unit_price: 1500, merchant_id: steph_merchant.id) 
        item2 = Item.create!(name: "Colorado Air", description: "Air in a can", unit_price: 2500, merchant_id: steph_merchant.id) 
        item3 = Item.create!(name: "Boulder", description: "It's a literal rock", unit_price: 3500, merchant_id: kev_merchant.id) 

        invoice1 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
        invoice2 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
        invoice3 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )

        invoice_item1 = InvoiceItem.create!(quantity:100, unit_price: 1500, status: "pending", item_id: item1.id, invoice_id: invoice1.id)
        invoice_item2 = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item2.id, invoice_id: invoice2.id)
        invoice_item3 = InvoiceItem.create!(quantity:100, unit_price: 3500, status: "pending", item_id: item3.id, invoice_id: invoice3.id)

        visit merchant_invoice_path(steph_merchant, invoice1)

        expect(page).to have_content(invoice1.id)
        expect(page).to have_content(invoice1.status)
        expect(page).to have_content(invoice1.created_at.strftime('%A, %B %d, %Y'))
        expect(page).to have_content("Saturday, August 27, 2022")
        expect(page).to have_content(invoice1.customer.first_name)
        expect(page).to have_content(invoice1.customer.last_name)
      end
    end
  end

  describe 'Merchant Invoice Show Page: Invoice Item Information' do
    describe 'When I visit my merchant invoice show page' do
      it 'Then I see all of my items on  invoice including: item name, qty of the item ordered, price item sold for, the Invoice Item status' do

        steph_merchant = Merchant.create!(name: "Stephen's shop")
        kev_merchant = Merchant.create!(name: "Kevin's shop")

        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")

        item1 = Item.create!(name: "Climbing Chalk", description: "Purest powder on the market", unit_price: 1500, merchant_id: steph_merchant.id) 
        item2 = Item.create!(name: "Colorado Air", description: "Air in a can", unit_price: 2500, merchant_id: steph_merchant.id) 
        item3 = Item.create!(name: "Boulder", description: "It's a literal rock", unit_price: 3500, merchant_id: kev_merchant.id) 

        invoice1 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
        invoice2 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
        invoice3 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )

        invoice_item1 = InvoiceItem.create!(quantity:100, unit_price: 1500, status: "packaged", item_id: item1.id, invoice_id: invoice1.id)
        invoice_item2 = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item2.id, invoice_id: invoice1.id)
        invoice_item3 = InvoiceItem.create!(quantity:90, unit_price: 3500, status: "pending", item_id: item3.id, invoice_id: invoice3.id)

        visit merchant_invoice_path(steph_merchant, invoice1)

        within"#item_#{item1.id}" do
          expect(page).to have_content(item1.name)
          expect(page).to have_content(invoice_item1.quantity)
          expect(page).to have_content("$15.00")
          expect(page).to have_content("Packaged")
        end

        within"#item_#{item2.id}" do
          expect(page).to have_content(item2.name)
          expect(page).to have_content(invoice_item2.quantity)
          expect(page).to have_content("$25.00")
          expect(page).to have_content("Packaged")
        end

        expect(page).to_not have_content(item3.name)
        expect(page).to_not have_content(invoice_item3.quantity)
        expect(page).to_not have_content(invoice_item3.unit_price)
        expect(page).to_not have_content(invoice_item3.status)   
      end
    end
  end

  describe 'Merchant Invoice Show Page: Total Revenue' do
    describe 'When I visit my merchant invoice show page' do
      it 'I see the total revenue that will be generated from all of my items on the invoice' do
        steph_merchant = Merchant.create!(name: "Stephen's shop")
        kev_merchant = Merchant.create!(name: "Kevin's shop")

        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")

        item1 = Item.create!(name: "Climbing Chalk", description: "Purest powder on the market", unit_price: 1500, merchant_id: steph_merchant.id) 
        item2 = Item.create!(name: "Colorado Air", description: "Air in a can", unit_price: 2500, merchant_id: steph_merchant.id) 
        item3 = Item.create!(name: "Boulder", description: "It's a literal rock", unit_price: 3500, merchant_id: kev_merchant.id) 

        invoice1 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
        invoice2 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
        invoice3 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )

        invoice_item1 = InvoiceItem.create!(quantity:100, unit_price: 1500, status: "packaged", item_id: item1.id, invoice_id: invoice1.id)
        invoice_item2 = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item2.id, invoice_id: invoice1.id)
        invoice_item3 = InvoiceItem.create!(quantity:90, unit_price: 3500, status: "pending", item_id: item3.id, invoice_id: invoice3.id)

        visit merchant_invoice_path(steph_merchant, invoice1)
        expect(page).to have_content("$4,000.00")
      end
    end
  end

  describe 'When I visit my merchant invoice show page' do
    describe 'I see that each invoice item status is a select field' do
      describe 'And I see that the invoice items current status is selected' do
        it 'When I select new status and click submit button, redirected to merchant invoice show, and item status is updated' do
          
          steph_merchant = Merchant.create!(name: "Stephen's shop")
          kev_merchant = Merchant.create!(name: "Kevin's shop")
          
          customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")
          
          item1 = Item.create!(name: "Climbing Chalk", description: "Purest powder on the market", unit_price: 1500, merchant_id: steph_merchant.id) 
          item2 = Item.create!(name: "Colorado Air", description: "Air in a can", unit_price: 2500, merchant_id: steph_merchant.id) 
          item3 = Item.create!(name: "Boulder", description: "It's a literal rock", unit_price: 3500, merchant_id: kev_merchant.id) 
          
          invoice1 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
          invoice2 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
          invoice3 = Invoice.create!(status: "completed", customer_id: customer1.id, created_at: "2022-08-27 10:00:00 UTC" )
          
          invoice_item1 = InvoiceItem.create!(quantity:100, unit_price: 1500, status: "packaged", item_id: item1.id, invoice_id: invoice1.id)
          invoice_item2 = InvoiceItem.create!(quantity:100, unit_price: 2500, status: "packaged", item_id: item2.id, invoice_id: invoice1.id)
          invoice_item3 = InvoiceItem.create!(quantity:90, unit_price: 3500, status: "pending", item_id: item3.id, invoice_id: invoice3.id)

          visit merchant_invoice_path(steph_merchant, invoice1)

          within("#invoice_item_#{invoice_item1.id}") do
            select "Shipped", from: "status"
            click_button "Update Item Status"
            
            expect(current_path).to eq(merchant_invoice_path(steph_merchant, invoice1))
            expect(invoice_item1.reload.status).to eq("shipped")
          end

          within("#invoice_item_#{invoice_item2.id}") do
            select "Shipped", from: "status"
            click_button "Update Item Status"
            
            expect(current_path).to eq(merchant_invoice_path(steph_merchant, invoice1))
            expect(invoice_item2.reload.status).to eq("shipped")
          end

        end
      end
    end
  end

  describe 'Merchant Invoice Show Page: Total Revenue and Discounted Revenue' do
    describe 'When I visit my merchant invoice show page I see the total revenue for my merchant from this invoice (not including discounts)' do
      it 'And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation' do

        merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
        merchant_roger = Merchant.create!(name: "Roger's Fancy Store")
        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")

        item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
        item_lamp = merchant_stephen.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 250)

        invoice1 = customer1.invoices.create!(status: "completed")
        invoice2 = customer1.invoices.create!(status: "completed")
    #both invoices_items should get the 20% discount, since 20% is the highest discount, and they are both over the 10 unit threshold
    #bulk_discount D is not included, since it is not for merchant_stephen
        invoice_itemA = invoice1.invoice_items.create!(quantity: 100, unit_price: 2500, status: "packaged", item_id: item_toothpaste.id)
        invoice_itemB = invoice1.invoice_items.create!(quantity: 15, unit_price: 1500, status: "packaged", item_id: item_lamp.id)

        bulk_discountA = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
        bulk_discountB = merchant_stephen.bulk_discounts.create(percentage_discount: 15, quantity_threshold: 15)
        bulk_discountC = merchant_stephen.bulk_discounts.create(percentage_discount: 50, quantity_threshold: 200)
        
        bulk_discountD = merchant_roger.bulk_discounts.create(percentage_discount: 18, quantity_threshold: 15)
        visit merchant_invoice_path(merchant_stephen, invoice1)
        
        expect(page).to have_content("Total Revenue: $2,725.00")
        expect(page).to have_content("Total Discounted Revenue: $2,180.00")

      end
    end
  end

  describe 'Merchant Invoice Show Page: Link to applied discounts' do
    describe 'When I visit my merchant invoice show page' do
      it 'Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)' do

        merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
        merchant_roger = Merchant.create!(name: "Roger's Fancy Store")
        customer1 = Customer.create!(first_name: "Abdul", last_name: "Redd")

        item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
        item_lamp = merchant_stephen.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 250)
        item_desk = merchant_roger.items.create!(name: "Item Desk", description: "sturdy desk", unit_price: 250)

        invoice1 = customer1.invoices.create!(status: "completed")
        invoice2 = customer1.invoices.create!(status: "completed")
        invoice3 = customer1.invoices.create!(status: "completed")

        invoice_itemA = invoice1.invoice_items.create!(quantity: 100, unit_price: 2500, status: "packaged", item_id: item_toothpaste.id)
        invoice_itemB = invoice1.invoice_items.create!(quantity: 15, unit_price: 1500, status: "packaged", item_id: item_lamp.id)
        invoice_itemC = invoice2.invoice_items.create!(quantity: 15, unit_price: 1500, status: "packaged", item_id: item_desk.id)

        bulk_discountA = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
        bulk_discountB = merchant_stephen.bulk_discounts.create(percentage_discount: 15, quantity_threshold: 15)
        bulk_discountC = merchant_stephen.bulk_discounts.create(percentage_discount: 50, quantity_threshold: 200)
        
        bulk_discountD = merchant_roger.bulk_discounts.create(percentage_discount: 18, quantity_threshold: 20)

        visit merchant_invoice_path(merchant_stephen, invoice1)

        within("#invoice_item_#{invoice_itemA.id}") do
          click_link("Bulk discount that was applied")
          expect(current_path).to eq(merchant_bulk_discount_path(merchant_stephen, bulk_discountA))
        end

        visit merchant_invoice_path(merchant_stephen, invoice2)

        within("#invoice_item_#{invoice_itemC.id}") do
          expect(page).to have_content("No bulk discount was applied")
        end

      end
    end
  end
end

