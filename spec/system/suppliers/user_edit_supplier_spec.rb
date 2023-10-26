require 'rails_helper'

describe 'Usuário edita um fornecedor' do 
  it 'a partir da tela inicial' do
    #Arrange --> criar um galpão no banco de dados
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    
    #Act --> abrir a aplicação, visitar o fornecedor, clicar em editar
    visit suppliers_path
    click_on 'ACME LTDA'
    click_on 'Editar'

    #Assert --> garantir que o formulário aparece
    expect(page).to have_content 'Editar Fornecedor'
    expect(page).to have_field('Razão Social', with: 'ACME LTDA')
    expect(page).to have_field('Nome Fantasia', with: 'ACME')
    expect(page).to have_field('CNPJ', with: '123456')
    expect(page).to have_field('Endereço', with: 'Avenida dos Coelhos, 50')
    expect(page).to have_field('Cidade', with: 'Manaus')
    expect(page).to have_field('Estado', with: 'AM')
    expect(page).to have_field('E-mail', with: 'contato@acme.com.br')
  end 

  it 'com sucesso' do
    #Arrange --> criar um fornecedor no banco de dados
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')
    
    #Act --> abrir a aplicação, visitar o fornecedor, clicar em editar, preenchi os dados que quero editar
    visit suppliers_path
    click_on 'ACME LTDA'
    click_on 'Editar'
    fill_in 'Razão Social', with: 'ACME Corp'
    fill_in 'CNPJ', with: '012345'
    fill_in 'Endereço', with: 'Avenida dos Coelhos, 1500'
    click_on 'Enviar'

    #Assert --> garantir que os dados foram modificados e voltar pro show do galpão para cf os dados
    expect(page).to have_content 'Fornecedor atualizado com sucesso'
    expect(page).to have_content 'ACME Corp'
    expect(page).to have_content 'Endereço: Avenida dos Coelhos, 1500'
    expect(page).to have_content 'CNPJ: 012345'
  end

  it 'e mantém os campos obrigatórios' do
    #Arrange --> criar um fornecedor no banco de dados
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '123456',
                                full_address: 'Avenida dos Coelhos, 50', city: 'Manaus', state: 'AM', 
                                email: 'contato@acme.com.br')

    #Act --> abrir a aplicação, visitar o fornecedor, clicar em editar
    visit suppliers_path
    click_on 'ACME LTDA'
    click_on 'Editar'
    fill_in 'Razão Social', with: ''
    fill_in 'Nome Fantasia', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'E-mail', with: ''
    click_on 'Enviar'

    #Assert --> garantir que a msg apareça caso campos obrigatorios não sejam preenchidos
    expect(page).to have_content 'Não foi possível atualizar o fornecedor'
  end
end