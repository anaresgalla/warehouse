require 'rails_helper'

describe 'Usuario visita tela inicial' do 
  it 'e vê o nome da app' do 
    # Arrange
# nesse caso específico, não há pre-requisitos pra essa primeira tarefa de abrir a página, então ele fica vazio
    
    # Act
    visit root_path #a / é pq é a tela inicial

    # Assert
    expect(page).to have_content('Galpões & Estoque')
    expect(page).to have_link('Galpões & Estoque', href: root_path)
  end 

  it 'e vê os galpões cadastrados' do 
    #Arrange
    #cadastrar 2 galpoes: RJ e Maceio
    Warehouse.create!(name:'Rio', code:'SDU', city:'Rio de Janeiro', area:60_000,
                     address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Warehouse.create!(name:'Maceio', code:'MCZ', city:'Maceio', area:50_000,
                     address: 'Av Atlantica, 50', cep: '80000-000', description: 'Perto do Aeroporto')

    #Act
    visit(root_path)

    #Assert
    #garantir que eu veja na tela os galpoes rio e maceio
    expect(page).not_to have_content('Não existem galpões cadastrados')
    expect(page).to have_content('Rio')
    expect(page).to have_content('SDU')
    expect(page).to have_content('Rio de Janeiro')
    expect(page).to have_content('60000 m²')

    expect(page).to have_content('Maceio')
    expect(page).to have_content('MCZ')
    expect(page).to have_content('Maceio')
    expect(page).to have_content('50000 m²')
  end 

  it 'e não existem galpoes cadastrados' do
    #Arrange

    #Act
    visit(root_path)
    #Assert
    expect(page).to have_content('Não existem galpões cadastrados')
  end 
end
