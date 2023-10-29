require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    #Arrange

    #Act
    visit root_path
    click_on 'Meus Pedidos'
    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    ana = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    first_order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now, status: 'pending')
    second_order = Order.create!(user: ana, warehouse: warehouse, supplier: supplier, 
                                 estimated_delivery_date: 1.day.from_now, status: 'delivered')
    third_order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now, status: 'canceled')
    #Act
    login_as(leandro)
    visit root_path
    click_on 'Meus Pedidos'
    #Assert
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content second_order.code
    expect(page).not_to have_content 'Entregue'
    expect(page).to have_content third_order.code
    expect(page).to have_content 'Cancelado'
  end

  it 'e visita um pedido' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    first_order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
    #Act
    login_as(leandro)
    visit root_path
    click_on 'Meus Pedidos'
    click_on first_order.code
    #Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'e não visita pedidos de outros usuários' do
    #Arrange
    leandro = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    ana = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    first_order = Order.create!(user: leandro, warehouse: warehouse, supplier: supplier, 
                                estimated_delivery_date: 1.day.from_now)
    #Act
    login_as(ana)
    visit order_path(first_order.id)
    #Assert
    expect(current_path).not_to eq order_path(first_order.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este pedido.'
  end

  it 'e vê itens do pedido' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: '156GT')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: '352KL')
    product_c = ProductModel.create!(name: 'Produto C', weight: 15, width: 10, height: 20,
                                     depth: 30, supplier: supplier, sku: '785PA')
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now)
    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    OrderItem.create!(product_model: product_b, order: order, quantity: 12)
    #Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    #Assert
    expect(page).to have_content 'Itens do Pedido'
    expect(page).to have_content '19 X Produto A'
    expect(page).to have_content '12 X Produto B'
  end
end