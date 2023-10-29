require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  
  describe 'gera um número de série' do
    it 'ao criar um StockProduct' do
    #Arrange
      w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
      s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                  full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                  email: 'contato@acme.com.br')   
      order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21', status: 'delivered')
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 10, width: 75, depth: 80,
                                     sku: 'CAD-13CD', supplier: s)
                                     
    #Act --> salvar no banco de dados
      stock_product = StockProduct.create!(order: order, warehouse: w, product_model: product)
    #Assert --> espero que o pedido tenha um código aleatório
      expect(stock_product.serial_number.length).to eq 20
    end

    it 'e não é modificado' do
      #Arrange
        w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                      city: 'Rio', area: 1000, description: 'Alguma descrição')
        warehouse = Warehouse.create!(name: 'Galpão RJ', code: 'SDU', address: 'Endereço', cep: '45000-000', 
                                      city: 'Rio de Janeiro', area: 1000, description: 'Alguma descrição')
        u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
        s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                    full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                    email: 'contato@acme.com.br')   
        order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21', status: 'delivered')
        product = ProductModel.create!(name: 'Cadeira Gamer', weight: 10, width: 75, depth: 80,
                                       sku: 'CAD-13CD', supplier: s)
        stock_product = StockProduct.create!(order: order, warehouse: w, product_model: product)
        original_serial_number = stock_product.serial_number                               
      #Act --> salvar no banco de dados
        stock_product.update(warehouse: warehouse)
      #Assert --> espero que o pedido tenha um código aleatório
        expect(stock_product.serial_number).to eq original_serial_number
    end
    
  end
  describe '#available?' do
    it 'true se não tiver destino' do
    #Arrange
      w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                            city: 'Rio', area: 1000, description: 'Alguma descrição')
      u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
      s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                           full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                           email: 'contato@acme.com.br')   
      order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21', status: 'delivered')
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 10, width: 75, depth: 80,
                                     sku: 'CAD-13CD', supplier: s)
    #Act --> salvar no banco de dados
      stock_product = StockProduct.create!(order: order, warehouse: w, product_model: product)
    #Assert --> espero que o pedido tenha um código aleatório
      expect(stock_product.available?).to eq true
    end

    it 'false se tiver destino' do
      #Arrange
      w = Warehouse.create!(name: 'Galpão Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                            city: 'Rio', area: 1000, description: 'Alguma descrição')
      u = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')   
      s = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                           full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                           email: 'contato@acme.com.br')   
      order = Order.create!(user: u, warehouse: w, supplier: s, estimated_delivery_date: '2023-11-21', status: 'delivered')
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 10, width: 75, depth: 80,
                                     sku: 'CAD-13CD', supplier: s)
      #Act --> salvar no banco de dados
      stock_product = StockProduct.create!(order: order, warehouse: w, product_model: product)
      stock_product.create_stock_product_destination!(recipient: 'Bia', address: 'Rua Z')
      #Assert --> espero que o pedido tenha um código aleatório
      expect(stock_product.available?).to eq false

    end
  end
end
