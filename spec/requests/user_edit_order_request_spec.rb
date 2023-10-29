require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
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
     patch(order_path(order.id), params: { order: { supplier_id: 3 }})
     #Assert
     expect(response).to redirect_to(root_path)
   end
 end 
 