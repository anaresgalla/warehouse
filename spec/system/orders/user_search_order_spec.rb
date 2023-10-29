require 'rails_helper'

describe 'Usuário busca por um pedido' do
  it 'a partir do menu' do
    #Arrange
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    #Act
    login_as(user) 
    visit root_path
    #Assert
    within('header nav') do
      expect(page).to have_field 'Buscar Pedido'
      expect(page).to have_button 'Buscar'
    end
  end
  it 'e deve estar autenticado' do
    #Arrange

    #Act
    visit root_path
    #Assert
    within('header nav') do
      expect(page).not_to have_field 'Buscar Pedido'
      expect(page).not_to have_button 'Buscar'
    end
  end 

  it 'e encontra um pedido' do
    #Arrange
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    #Act
    login_as(user) 
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'
    #Assert
    expect(page).to have_content "Resultados da Busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
  end

  it 'e encontra múltiplos pedidos' do
    #Arrange
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    second_warehouse = Warehouse.create!(name: 'Aeroporto do Rio', code: 'SDU', city: 'Rio de Janeiro', area: 100_000, 
                                  address: 'Avenida do Porto, 7000', cep: '25000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU12345')
    first_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU9875')
    second_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('SDU0000')
    third_order = Order.create!(user: user, warehouse: second_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    #Act
    login_as(user) 
    visit root_path
    fill_in 'Buscar Pedido', with: 'GRU'
    click_on 'Buscar'
    #Assert
    expect(page).to have_content ('2 pedidos encontrados')
    expect(page).to have_content ('GRU12345')
    expect(page).to have_content ('GRU9875')
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).not_to have_content ('SDU0000')
    expect(page).not_to have_content 'Galpão Destino: SDU - Aeroporto do Rio'
  end
end
