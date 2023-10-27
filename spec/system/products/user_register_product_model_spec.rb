require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do
  it 'com sucesso' do
    #Arrange
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Inc.', registration_number: '741852',
                                full_address: 'Av das Nações Unidas, 751', city: 'São Paulo', state: 'SP', 
                                email: 'sac@samsung.com.br')
    other_supplier = Supplier.create!(brand_name: 'LG', corporate_name: 'LG Inc.', registration_number: '458792',
                                full_address: 'Av das Américas, 4562', city: 'Vitória', state: 'ES', 
                                email: 'sac@lg.com.br')
    #Act
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Produto', with: 'TV 32'
    fill_in 'Peso', with: 8000
    fill_in 'Largura', with: 70
    fill_in 'Altura', with: 45
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV32-SAMS-XPTO90'
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'

    #Assert
    expect(page).to have_content 'Modelo de produto cadastrado com sucesso!'
    expect(page).to have_content 'TV 32'
    expect(page).to have_content 'Fornecedor: Samsung'
    expect(page).to have_content 'SKU: TV32-SAMS-XPTO90'
    expect(page).to have_content 'Dimensão: 70cm x 45cm x 10cm'
    expect(page).to have_content 'Peso: 8000g'
  end

  it 'deve preencher todos os campos' do 
    #Arrange
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Inc.', registration_number: '741852',
                                full_address: 'Av das Nações Unidas, 751', city: 'São Paulo', state: 'SP', 
                                email: 'sac@samsung.com.br')
    
    #Act
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Produto', with: ''
    fill_in 'SKU', with: ''    
    click_on 'Enviar'
    
    #Assert
    expect(page).to have_content 'Não foi possível cadastrar o modelo de produto.'
  end
end