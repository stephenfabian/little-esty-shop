class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.find(params[:id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
  end


  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.merchant_invoice_finder    
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])

    
  end
end
