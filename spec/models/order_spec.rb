require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      #Arrange
      w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
      s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                  full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                  email: 'contato@acme.com.br')   
      order = Order.new(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21')
      #Act
      result = order.valid?
      #Assert
      expect(result).to be true
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar um novo pedido' do
    #Arrange --> criar um pedido (somente o objeto.new) com todos os campos menos o código
      w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
      s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                  full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                  email: 'contato@acme.com.br')   
      order = Order.new(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21')
    #Act --> salvar no banco de dados
      order.save!
      result = order.code
    #Assert --> espero que o pedido tenha um código aleatório
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'e o código é único' do
    #Arrange --> criar um pedido (somente o objeto.new) com todos os campos menos o código
      w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                            city: 'Rio', area: 1000, description: 'Alguma descrição')
      u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
      s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                            full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                            email: 'contato@acme.com.br')   
      first_order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21')
      second_order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-05-07')
    #Act --> salvar no banco de dados
      second_order.save!
    #Assert --> espero que o pedido tenha um código aleatório
      expect(second_order.code).not_to eq first_order.code
    end
  end
end
