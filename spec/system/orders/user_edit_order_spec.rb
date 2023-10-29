require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
    #Act
    visit edit_order_path(order.id)
    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    Supplier.create!(corporate_name: 'Stark Industries LTDA', brand_name: 'Stark', registration_number: '789123',
                     full_address: 'Avenida Industrial, 1000', city: 'Curitiba', state: 'PR', email: 'contato@stark.com.br')
    order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
    #Act
    login_as(leandro)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: '12/12/2023'
    select 'Stark Industries LTDA', from: 'Fornecedor'
    click_on 'Gravar'
    #Assert
    expect(page).to have_content 'Pedido atualizado com sucesso!'
    expect(page).to have_content 'Fornecedor: Stark Industries LTDA'
    expect(page).to have_content 'Data Prevista de Entrega: 12/12/2023'
  end

  it 'caso seja o responsável' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    ana = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
    #Act
    login_as(ana)
    visit edit_order_path(order.id)
    #Assert
    expect(current_path).to eq root_path
  end
end 
