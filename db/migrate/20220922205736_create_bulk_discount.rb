class CreateBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percentage_discount
      t.integer :quantity_threshold
      t.belongs_to :merchant, foreign_key: true
      t.timestamps
    end
  end
end
