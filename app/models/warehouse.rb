class Warehouse < ApplicationRecord
  validates :name, :code, :city, :description, :address, :cep, :area, presence: true
  # o formato da validação é validates atributos, tipos de validação: (true por exemplo)
  #não pode passar duas validações para o mesmo atributo ao mesmo tempo = na mesma linha. 
  # por exemplo: para validar o code pela presença e pelo nunero de caracteres, teria q validar cada um em uma linha de código separada 
  #ex: validades :code, presence: true  E  validades :code, length {is: 3}
end
