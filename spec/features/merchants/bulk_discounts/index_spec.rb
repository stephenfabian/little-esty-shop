require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index' do
  describe 'When I visit my merchant dashboard' do
    describe 'Then I see a link to view all my discounts' do
      describe 'When I click this link' do
        describe 'Then I am taken to my bulk discounts index page' do
          describe 'I see all of my bulk discounts including their % discount and qty thresholds' do
            it 'And each bulk discount listed includes a link to its show page' do

              merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
              merchant_roger = Merchant.create!(name: "Roger's Fancy Store")

              item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
              item_lamp = merchant_roger.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 4000)

              bulk_discount1 = merchant_stephen.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)
              bulk_discount2 = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
              bulk_discount3 = merchant_roger.bulk_discounts.create(percentage_discount: 5, quantity_threshold: 10)

              visit "/merchants/#{merchant_stephen.id}/dashboard"
              click_link("View All Discounts")

              expect(current_path).to eq(merchant_bulk_discounts_path(merchant_stephen))
              save_and_open_page
              expect(page).to have_content("Discount: #{bulk_discount1.percentage_discount}% off if customer buys #{bulk_discount1.quantity_threshold} or more items")
              expect(page).to have_content("Discount: #{bulk_discount2.percentage_discount}% off if customer buys #{bulk_discount2.quantity_threshold} or more items")
              expect(page).to_not have_content("Discount: #{bulk_discount3.percentage_discount}% off if customer buys #{bulk_discount3.quantity_threshold} or more items")

            end
          end
        end
      end
    end
  end
end