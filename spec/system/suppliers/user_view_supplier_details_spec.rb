require 'rails_helper'

describe 'Usuário vê detalhes do fornecedor' do 
  it 'a partir da tela inicial' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                     full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', email: 'contato@acme.com.br')

    #Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME LTDA'
    #Assert
    expect(page).to have_content('ACME LTDA')
    expect(page).to have_content('CNPJ: 123456')
    expect(page).to have_content('Endereço: Avenida dos Coelhos, 50 - Manaus - AM')
    expect(page).to have_content('E-mail: contato@acme.com.br')
  end

  it 'e volta para a tela inicial' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                     full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', email: 'contato@acme.com.br')
    #Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME LTDA'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end
