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

    it 'data estimada de entrega deve ser obrigatória' do
      #Arrange
      order = Order.new(estimated_delivery_date: '')
      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)
      #Assert
      expect(result).to be true
    end

    it 'data estimada de entrega não deve ser passada' do
      #Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)
      #Act
      order.valid?
      #Assert
      expect(order.errors.include?(:estimated_delivery_date)).to be true
      expect(order.errors[:estimated_delivery_date]).to include('deve ser futura.')
    end 

    it 'data estimada de entrega não deve ser igual a hoje' do
      #Arrange
      order = Order.new(estimated_delivery_date: Date.today)
      #Act
      order.valid?
      #Assert
      expect(order.errors.include?(:estimated_delivery_date)).to be true
      expect(order.errors[:estimated_delivery_date]).to include('deve ser futura.')
    end 

    it 'data estimada de entrega deve ser igual ou maior que amanhã' do
      #Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)
      #Act
      order.valid?
      #Assert
      expect(order.errors.include?(:estimated_delivery_date)).to be false
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
      second_order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-12-07')
    #Act --> salvar no banco de dados
      second_order.save!
    #Assert --> espero que o pedido tenha um código aleatório
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      #Arrange 
      user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                            city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                           full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                           email: 'contato@acme.com.br')   
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now)
      original_code = order.code
      #Act --> salvar no banco de dados
      order.update!(estimated_delivery_date: 1.month.from_now)
      #Assert --> espero que o pedido tenha um código aleatório
      expect(order.code).to eq(original_code)
      end
  end
end
