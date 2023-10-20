require 'rails_helper'

describe 'Usuario visita tela inicial' do 
  it 'e vê o nome da app' do 
    # Arrange
# nesse caso específico, não há pre-requisitos pra essa primeira tarefa de abrir a página, então ele fica vazio
    
    # Act
    visit('/') #a / é pq é a tela inicial

    # Assert
    expect(page).to have_content('Galpões & Estoque')
  end 
end
