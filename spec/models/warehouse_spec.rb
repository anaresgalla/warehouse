require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do #(tem o # pq é teste de instâncias da classe)
    context 'presence' do #agrega todos os testes unitários do mesmo tipo
      it 'false when name is empty' do
        #Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 
      end 

      it 'false when code is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Endereço', cep: '25000-000', 
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 

        ############ essa linha substitui as linhas de act e assert -> expect(warehouse).not_to be_valid
        #pq executa o valid? e espera que ele seja falso
      end 

      it 'false when address is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '', cep: '25000-000', 
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 
        ####### posso refatorar o código excluindo a linha act, deixando ela junto com a parte do assert:
        #expect(warehouse.valid?).to eq false
      end

      it 'false when cep is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '', 
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 
      end 

      it 'false when city is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                  city: '', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 
      end 

      it 'false when area is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                  city: 'Rio', area: nil, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 
      end 

      it 'false when description is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                  city: 'Rio', area: 1000, description: '')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false 
      end 
    end 

      it 'false when code is already in use' do
        #Arrange: Criar 2 galpões, Repetir o código
        first_warehouse = Warehouse.create(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000', 
                                           city: 'Rio', area: 1000, description: 'Alguma descrição')
        second_warehouse = Warehouse.new(name: 'Niteroi', code: 'RIO', address: 'Avenida', cep: '27000-000', 
                                            city: 'Niteroi', area: 2000, description: 'Outra descrição')
        
        #Act: Perguntar para o 2º galpão se ele é valido
        result = second_warehouse.valid?
        
        #Assert: Espero que seja false(não pode ser válido)
        expect(result).to eq false 
      end
  end   
  
  describe '#full_description' do
    it 'e exibe o nome e o código' do
      #Arrange
      w = Warehouse.new(name: 'Galpão Cuiabá', code: 'CBA')
      #Act
      result = w.full_description
      #Assert
      expect(result).to eq ('CBA - Galpão Cuiabá')
    end 
  end
end
