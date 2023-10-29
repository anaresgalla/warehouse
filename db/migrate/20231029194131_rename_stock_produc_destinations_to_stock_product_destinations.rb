class RenameStockProducDestinationsToStockProductDestinations < ActiveRecord::Migration[7.1]
  def change
    rename_table :stock_produc_destinations, :stock_product_destinations
  end
end
