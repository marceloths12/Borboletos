class BilletsController < ApplicationController
  before_action :set_billet, only: %i[ show edit update destroy ]

  def index
    @billets = Billet.all
  end

  def show
  end

  def new
    @billet = Billet.new
  end

  def edit
  end

  def create
    @billet = Billet.new(billet_params)

    respond_to do |format|
      if @billet.save
        format.html { redirect_to billet_url(@billet), notice: "Billet was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @billet.update(billet_params)
        format.html { redirect_to billet_url(@billet), notice: "Billet was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @billet.destroy!

    respond_to do |format|
      format.html { redirect_to billets_url, notice: "Billet was successfully destroyed." }
    end
  end

  private
    def set_billet
      @billet = Billet.find(params[:id])
    end

    def billet_params
      params.require(:billet).permit(:amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state, :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood, :customer_number, :customer_complement)
    end
end
