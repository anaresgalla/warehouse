class HomeController < ApplicationController
  def index
    @warehouses = Warehouse.all 
    @suppliers = Supplier.all
  end
end