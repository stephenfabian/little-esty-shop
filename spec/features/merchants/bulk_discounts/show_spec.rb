require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Feature' do

  describe 'Merchant Bulk Discount Show' do
    it 'When I visit my bulk discount show page, I see the bulk discounts quantity threshold and percentage discount' do
      merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
      merchant_roger = Merchant.create!(name: "Roger's Fancy Store")

      item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
      item_lamp = merchant_roger.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 4000)

      bulk_discount1 = merchant_stephen.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)
      bulk_discount2 = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
      bulk_discount3 = merchant_roger.bulk_discounts.create(percentage_discount: 7, quantity_threshold: 10)

      visit merchant_bulk_discount_path(merchant_stephen, bulk_discount1)
      save_and_open_page
      expect(page).to have_content(bulk_discount1.percentage_discount)
      expect(page).to have_content(bulk_discount1.quantity_threshold)
      expect(page).to_not have_content(bulk_discount3.percentage_discount)
      expect(page).to_not have_content(bulk_discount3.quantity_threshold)
      expect(page).to_not have_content(bulk_discount2.quantity_threshold)
      expect(page).to_not have_content(bulk_discount2.quantity_threshold)

    end
  end
end