require 'rails_helper'

describe 'Usuário vê fornecedores' do
  it 'a partir do menu' do
    #Arrange

    #Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end 
    #Assert
    expect(current_path).to eq suppliers_path
  end

  it 'com sucesso' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                     full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', email: 'contato@acme.com.br')
    Supplier.create!(corporate_name: 'Stark Industries LTDA', brand_name: 'Stark', registration_number: '789123',
                     full_address: 'Avenida Industrial, 1000', city: 'Curitiba', state: 'PR', email: 'contato@stark.com.br')

    #Act
    visit root_path
    click_on 'Fornecedores'

    #Assert
    expect(page).to have_content('Fornecedores')
    expect(page).to have_content('ACME')
    expect(page).to have_content('Manaus - AM')
    expect(page).to have_content('Stark')
    expect(page).to have_content('Curitiba - PR')
  end

  it 'e não existem fornecedores cadastrados' do
    #Arrange

    #Act 
    visit root_path
    click_on 'Fornecedores'
    #Assert
    expect(page).to have_content 'Não existem fornecedores cadastrados.'
  end
end