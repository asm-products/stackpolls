class ItemRanksController < ApplicationController
  before_action :set_item_rank, only: [:show, :edit, :update, :destroy]

  # GET /item_ranks
  # GET /item_ranks.json
  def index
    @item_ranks = ItemRank.all
  end

  # GET /item_ranks/1
  # GET /item_ranks/1.json
  def show
  end

  # GET /item_ranks/new
  def new
    @item_rank = ItemRank.new
  end

  # GET /item_ranks/1/edit
  def edit
  end

  # POST /item_ranks
  # POST /item_ranks.json
  def create
    @item_rank = ItemRank.new(item_rank_params)

    respond_to do |format|
      if @item_rank.save
        format.html { redirect_to @item_rank, notice: 'Item rank was successfully created.' }
        format.json { render :show, status: :created, location: @item_rank }
      else
        format.html { render :new }
        format.json { render json: @item_rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_ranks/1
  # PATCH/PUT /item_ranks/1.json
  def update
    respond_to do |format|
      if @item_rank.update(item_rank_params)
        format.html { redirect_to @item_rank, notice: 'Item rank was successfully updated.' }
        format.json { render :show, status: :ok, location: @item_rank }
      else
        format.html { render :edit }
        format.json { render json: @item_rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_ranks/1
  # DELETE /item_ranks/1.json
  def destroy
    @item_rank.destroy
    respond_to do |format|
      format.html { redirect_to item_ranks_url, notice: 'Item rank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_rank
      @item_rank = ItemRank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_rank_params
      params.require(:item_rank).permit(:response_id, :survey_item_id, :rank)
    end
end
