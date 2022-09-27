class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  enum status: [ "pending", "packaged", "shipped" ]

  def item_name
    item.name
  end

  def discount_to_use
    BulkDiscount.joins(merchant: [items: :invoices])
    .where("#{self.quantity} >= quantity_threshold and bulk_discounts.merchant_id = #{self.item.merchant_id}")
    .order(percentage_discount: :desc)
    .group(:id)
    .first
  end

  def invoice_item_revenue
    self.unit_price * self.quantity
  end

  def invoice_item_discounted_revenue
    if self.discount_to_use == nil
        invoice_item_revenue 
    else
      discount = ((self.discount_to_use).percentage_discount)/100.to_f
      discounted_revenue = invoice_item_revenue - (invoice_item_revenue * discount)
      discounted_revenue
    end
  end
end
