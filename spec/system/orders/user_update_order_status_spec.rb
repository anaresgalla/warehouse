require 'rails_helper'

describe 'Usuário informa novo status de pedido' do
  it 'e pedido foi entregue' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now, status: :pending)
    #Act
    login_as leandro
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como ENTREGUE'
    #Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Situação do Pedido: Entregue'
    expect(page).not_to have_button 'Marcar como CANCELADO'
  end
  
  it 'e pedido foi cancelado' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now, status: :pending)
    #Act
    login_as leandro
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como CANCELADO'
    #Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Situação do Pedido: Cancelado'
  end
end