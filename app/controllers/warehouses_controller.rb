class WarehousesController < ApplicationController
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  def show
    @stocks = @warehouse.stock_products.where.missing(:stock_product_destination).group(:product_model).count
    @product_models = ProductModel.all
  end 

  def new
    @warehouse = Warehouse.new
  end

  def create
    #É aqui dentro que vamos: #1- Receber os dados enviados
    #2- Criar um novo GALPÃO(nesse caso) no banco de dados
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

  def edit; end 

  def update
    if @warehouse.update(warehouse_params)
        redirect_to warehouse_path(@warehouse.id), notice: 'Galpão atualizado com sucesso!'
    else 
      flash.now[:notice] = 'Não foi possível atualizar o galpão'
      render 'edit'
    end 
  end

  def destroy
    @warehouse.destroy  #ou  @warehouse.delete
    redirect_to root_path, notice: 'Galpão removido com sucesso!'
  end

  private #pra indicar que não é uma action
  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :code, :city, :address,
                                      :description, :cep, :area) #=> STRONG PARAMETERS
  end
end 