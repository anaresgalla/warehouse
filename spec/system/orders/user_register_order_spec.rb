require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    #Arrange
    #Act
    visit root_path
    click_on 'Registrar Pedido'
    #Assert
    expect(current_path).to eq new_user_session_path
  end 

  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Leandro', email: 'leandro@email.com', password: 'password')
    Warehouse.create!(name:'Galpão Maceio', code:'MCZ', city:'Maceio', area:50_000,
                     address: 'Av Atlantica, 50', cep: '80000-000', description: 'Perto do Aeroporto')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    Supplier.create!(corporate_name: 'Stark Industries LTDA', brand_name: 'Stark', registration_number: '789123',
                     full_address: 'Avenida Industrial, 1000', city: 'Curitiba', state: 'PR', 
                     email: 'contato@stark.com.br')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    
    ### configuração futura --> sei que em algum momento a app vai executar o método SecureRandom.alphanumeric
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345') #--> só serve durante a execução desse teste

    #Act
    login_as(user) 
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in "Data Prevista de Entrega", with: '30/10/2023'
    click_on 'Gravar'

    #Assert
    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    expect(page).to have_content 'Usuário Responsável: Leandro - leandro@email.com'
    expect(page).to have_content 'Data Prevista de Entrega: 30/10/2023'
    expect(page).not_to have_content 'Galpão Maceio'
    expect(page).not_to have_content 'Stark Industries LTDA'
  end 
end 