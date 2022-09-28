require 'rails_helper'

RSpec.describe 'User Story 1 - Merchant Bulk Discounts Index' do
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
              expect(page).to have_content("Discount: #{bulk_discount1.percentage_discount}% off if customer buys #{bulk_discount1.quantity_threshold} or more items")
              expect(page).to have_content("Discount: #{bulk_discount2.percentage_discount}% off if customer buys #{bulk_discount2.quantity_threshold} or more items")
              expect(page).to_not have_content("Discount: #{bulk_discount3.percentage_discount}% off if customer buys #{bulk_discount3.quantity_threshold} or more items")

              within("#discount-#{bulk_discount1.id}") do
              click_link("Discount's Show Page")
              expect(current_path).to eq(merchant_bulk_discount_path(merchant_stephen, bulk_discount1))
              end

              visit merchant_bulk_discounts_path(merchant_stephen)

              within("#discount-#{bulk_discount2.id}") do
              click_link("Discount's Show Page")
              expect(current_path).to eq(merchant_bulk_discount_path(merchant_stephen, bulk_discount2))
              end

            end
          end
        end
      end
    end
  end


  describe 'User Story 2 - Merchant Bulk Discount Create' do
    describe 'When I visit my bulk discounts index I see a link to create a new discount' do
      describe 'click link, then I am taken to a new page where I see a form to add a new bulk discount' do
        describe 'When I fill in the form with valid data and submit, Im redirected back to bulk discount index' do
          it 'and see my new bulk discount listed' do

            merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")
            merchant_roger = Merchant.create!(name: "Roger's Fancy Store")

            item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )
            item_lamp = merchant_roger.items.create!(name: "Item Lamp", description: "You bet, it's a lamp", unit_price: 4000)

            bulk_discount1 = merchant_stephen.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)

            visit merchant_bulk_discounts_path(merchant_stephen)
            click_link("Create a new discount")

            expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_stephen))

            fill_in "Percentage discount", with: 40
            fill_in "Quantity threshold", with: 30
            click_button "Save"

            expect(current_path).to eq(merchant_bulk_discounts_path(merchant_stephen))
            expect(page).to have_content("Discount: 40% off if customer buys 30 or more items")
            expect(page).to have_content("Discount: 30% off if customer buys 15 or more items")
          end
        end
      end
    end
  end

  describe 'Merchant Bulk Discount Delete' do
    describe 'When I visit my bulk discounts index, next to each bulk discount I see a link to delete it' do
      it 'When I click this link, I am redirected back to the bulk discounts index page, discount is not listed' do
        merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")

        item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )

        bulk_discount1 = merchant_stephen.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)
        bulk_discount2 = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
        bulk_discount3 = merchant_stephen.bulk_discounts.create(percentage_discount: 10, quantity_threshold: 5)

        visit merchant_bulk_discounts_path(merchant_stephen)
        within("#discount-#{bulk_discount1.id}") do
          click_link("Delete")
        end

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant_stephen))
        expect(page).to_not have_content("Discount: #{bulk_discount1.percentage_discount}% off if customer buys #{bulk_discount1.quantity_threshold} or more items")
        expect(page).to have_content("Discount: #{bulk_discount2.percentage_discount}% off if customer buys #{bulk_discount2.quantity_threshold} or more items")
      end
    end
  end

  describe 'User Story 9 - API Story - Upcoming Holidays header' do
    describe 'When I visit the discounts index page' do
      describe 'I see a section with a header of "Upcoming Holidays' do
        it 'within this section the name and date of the next 3 upcoming US holidays are listed' do

          merchant_stephen = Merchant.create!(name: "Stephen's Shady Store")

          item_toothpaste = merchant_stephen.items.create!(name: "Item Toothpaste", description: "The worst toothpaste you can find", unit_price: 4000 )

          bulk_discount1 = merchant_stephen.bulk_discounts.create(percentage_discount: 30, quantity_threshold: 15)
          bulk_discount2 = merchant_stephen.bulk_discounts.create(percentage_discount: 20, quantity_threshold: 10)
          bulk_discount3 = merchant_stephen.bulk_discounts.create(percentage_discount: 10, quantity_threshold: 5)

          visit merchant_bulk_discounts_path(merchant_stephen)

          within("#upcoming_holidays") do
          expect("Columbus Day").to appear_before("Veterans Day")
          expect("Veterans Day").to appear_before("Thanksgiving Day")
          end

        end
      end
    end
  end
end