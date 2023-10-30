require 'rails_helper'

describe 'Warehouse API' do
  context 'GET /api/v1/warehouses/1' do
    it 'success' do
      #Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      
      #Act
      get "/api/v1/warehouses/#{warehouse.id}"

      #Assert
      expect(response.status).to eq 200 
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      
      expect(json_response["name"]).to eq('Aeroporto SP')
      expect(json_response["code"]).to eq('GRU')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'fail if warehouse not found' do
      #Arrange
      #Act
      get '/api/v1/warehouses/999999'
      #Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET/api/v1/warehouses' do
    it 'list all warehouses ordered by name' do
      #Arrange
      warehouse_a = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000, 
                                      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                      description: 'Galpão destinado para cargas internacionais')
      warehouse_b = Warehouse.create!(name: 'Aeroporto MG', code: 'BHZ', city: 'Belo Horizonte', area: 50_000, 
                                      address: 'Avenida do Contorno, 8000', cep: '35000-000',
                                      description: 'Galpão destinado para cargas do sudeste')
      #Act
      get "/api/v1/warehouses"
      #Assert
      expect(response.status).to eq 200 
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response [0]['name']).to eq 'Aeroporto MG'
      expect(json_response [1]['name']).to eq 'Aeroporto SP'
    end

    it 'return empty if there is no warehouse' do
      #Arrange
      
      #Act
      get "/api/v1/warehouses"
      #Assert
      expect(response.status).to eq 200 
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end
  end
end 