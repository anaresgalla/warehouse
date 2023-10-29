require 'rails_helper'

describe 'Usuário adiciona itens a um pedido' do
  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: '156GT')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: '352KL')

    #Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    select 'Produto A', from: 'Produto'
    fill_in 'Quantidade', with: '8'
    click_on 'Gravar'
    #Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso!'
    expect(page).to have_content '8 x Produto A'               
  end 

  it 'e não vê produtos de outro fornecedor' do
    #Arrange
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier_a = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    supplier_b = Supplier.create!(corporate_name: 'Stark Industries LTDA', brand_name: 'Stark', registration_number: '789123',
                                  full_address: 'Avenida Industrial, 1000', city: 'Curitiba', state: 'PR', email: 'contato@stark.com.br')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, 
                          estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier_a, sku: '156GT')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier_b, sku: '352KL')

    #Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    #Assert
    expect(page).not_to have_content 'Produto B'
    expect(page).to have_content 'Produto A'               
  end 
end 
