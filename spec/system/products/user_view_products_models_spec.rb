require 'rails_helper'

describe 'Usuário vê modelos de produtos' do

  it 'se estiver autenticado' do
    #Arrange -> nada

    #Act --> tenta acessar a tela sem estar autenticado
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end
    #Assert --> é chutado pelo Devise --> espero ir para a tela de login
    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    #Arrange
    user = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
       
    within('nav') do
      click_on 'Modelos de Produtos'
    end
  
    #Assert
    expect(current_path).to eq product_models_path
  end

  it 'com sucesso' do 
    #Arrange --> Criar modelos de produtos
    user = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Inc.', registration_number: '741852',
                                full_address: 'Av das Nações Unidas, 751', city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
                         sku: 'TV32-SAMS-XPTO90', supplier: supplier)
    ProductModel.create!(name: 'Soundbar - 7.1 Surround', weight: 3000, width: 80, height: 15, depth: 20, 
                         sku: 'SOU71-SAMS-NOIZ77', supplier: supplier)
    #Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end
    #Assert --> garantir que os dados aparecem
    expect(page).to have_content 'TV 32'
    expect(page).to have_content 'TV32-SAMS-XPTO90'
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'Soundbar - 7.1 Surround'
    expect(page).to have_content 'SOU71-SAMS-NOIZ77'
    expect(page).to have_content 'Samsung'
  end

  it 'e não existem produtos cadastrados' do
    #Arrange
    user = User.create!(name: 'Ana', email: 'ana@email.com', password: 'password')
    #Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    #Assert
    expect(page).to have_content 'Nenhum modelo de produto cadastrado.'
  end 
end
