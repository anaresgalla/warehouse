require 'rails_helper'

describe 'Usuário remove um galpão' do 
  it 'com sucesso' do
    #Arrange --> criar um galpão
    w = Warehouse.create!(name: 'Cuiaba', code: 'CWB', area: 10000, cep: '56000-000',
                          city: 'Cuiabá', description: 'Galpão no centro do país', address: 'Av dos Jacarés, 1000')
    
    #Act --> visitar tela inicial, abrir o galpão, clicar en remover
    visit root_path
    click_on 'Cuiaba'
    click_on 'Remover'

    #Assert --> espero que o galpão não apareça na lista de galpões da tela inicial
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso!'
    expect(page).not_to have_content 'Cuiaba'
    expect(page).not_to have_content 'CWB'
    expect(page).not_to have_content 10000
  end 

  it 'e não apaga outros galpões' do
    #Arrange --> criar um galpão
    first_warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CWB', area: 10000, cep: '56000-000',
                          city: 'Cuiabá', description: 'Galpão no centro do país', address: 'Av dos Jacarés, 1000')
    second_warehouse = Warehouse.create!(name: 'Belo Horizonte', code: 'BHZ', area: 20000, cep: '46000-000',
                          city: 'Belo Horizonte', description: 'Galpão para cargas mineiras', address: 'Av Tiradentes, 20')
    
    #Act --> visitar tela inicial, abrir o galpão, clicar en remover
    visit root_path
    click_on 'Cuiaba'
    click_on 'Remover'

    #Assert --> espero que o galpão não apareça na lista de galpões da tela inicial
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso!'
    expect(page).not_to have_content 'Cuiaba'
    expect(page).to have_content 'Belo Horizonte'

  end 
end