require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    #Arrange
    User.create!(email: 'ana@email.com', password: 'password')

    #Act
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'ana@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    
    #Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_link 'Sair'
      expect(page).to have_content 'ana@email.com'
    end
  end
end