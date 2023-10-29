require 'rails_helper'

describe 'Usuário vê o estoque' do
  it 'na tela do galpão' do
    #Arrange 
    user = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000', 
                                    description: 'Galpão de cargas internacionais')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Inc.', registration_number: '741852',
                                full_address: 'Av das Nações Unidas, 751', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: warehouse,
                          estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                                    sku: 'TV32-SAMS-XPTO90', supplier: supplier)
    product_b = ProductModel.create!(name: 'Soundbar - 7.1 Surround', weight: 3000, width: 80, height: 15, depth: 20, 
                                    sku: 'SOU71-SAMS-NOIZ77', supplier: supplier)
    product_c = ProductModel.create!(name: 'Notebook SamBook- ', weight: 2000, width: 50, height: 9, depth: 30, 
                                    sku: 'NOTE-45-SAM', supplier: supplier)
    3.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a) }
    2.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_c) }
                  
    #Act 
    login_as user
    visit root_path
    click_on 'Aeroporto SP'
    #Assert 
    expect(page).to have_content 'Itens em Estoque'
    expect(page).to have_content '3 x TV32-SAMS-XPTO90'
    expect(page).to have_content '2 x NOTE-45-SAM'
    expect(page).not_to have_content 'SOU71-SAMS-NOIZ77'
  end
end
