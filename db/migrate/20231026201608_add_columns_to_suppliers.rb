class AddColumnsToSuppliers < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :corporate_name, :string
    add_column :suppliers, :brand_name, :string
    add_column :suppliers, :full_address, :string
    add_column :suppliers, :registration_number, :string
    add_column :suppliers, :city, :string
    add_column :suppliers, :state, :string
    add_column :suppliers, :email, :string
  end
end
