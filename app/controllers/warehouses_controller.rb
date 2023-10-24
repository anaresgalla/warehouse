class WarehousesController < ApplicationController
  def show
    id = params[:id]
    @warehouse = Warehouse.find(id)
  end 

  def new
    @warehouse = Warehouse.new
  end

  def create
    #É aqui dentro que vamos:
    #1- Receber os dados enviados

    #2- Criar um novo GALPÃO(nesse caso) no banco de dados
    warehouse_params = params.require(:warehouse).permit(:name, :code, :city, :address,
                                       :description, :cep, :area) #=> STRONG PARAMETERS
    @warehouse = Warehouse.new(warehouse_params)
    if @warehouse.save
    #3- Redirecionar para a TELA INICIAL(nesse caso)
    #flash[:notice] = "Galpão cadastrado com sucesso!" --> uma das formas de escrever o flash, mas pode usar o notice ou o alert com o redirect direto, como abaixo:
      redirect_to root_path, notice: 'Galpão cadastrado com sucesso!'
    else 
      flash.now[:notice] = 'Galpão não cadastrado.'
      render 'new'
    end
  end 
end 