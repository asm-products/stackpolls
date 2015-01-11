class SurveyItemsController < ApplicationController
  before_filter :enforce_auth
  before_action :set_survey
  before_action :set_survey_item, only: [:show, :edit, :update, :destroy]

  # GET /survey_items
  # GET /survey_items.json
  def index
    @survey_items = @survey.survey_items.all
  end

  # GET /survey_items/1
  # GET /survey_items/1.json
  def show
  end

  # GET /survey_items/new
  def new
    @survey_item = @survey.survey_items.build
  end

  # GET /survey_items/1/edit
  def edit
  end

  # POST /survey_items
  # POST /survey_items.json
  def create
    @survey_item = @survey.survey_items.build(survey_item_params)

    respond_to do |format|
      if @survey_item.save
        format.html { redirect_to [@survey_item.survey, @survey_item], notice: 'Survey item was successfully created.' }
        format.json { render :show, status: :created, location: [@survey_item.survey, @survey_item] }
      else
        format.html { render :new }
        format.json { render json: @survey_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_items/1
  # PATCH/PUT /survey_items/1.json
  def update
    respond_to do |format|
      if @survey_item.update(survey_item_params)
        format.html { redirect_to [@survey_item.survey, @survey_item], notice: 'Survey item was successfully updated.' }
        format.json { render :show, status: :ok, location: [@survey_item.survey, @survey_item] }
      else
        format.html { render :edit }
        format.json { render json: @survey_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_items/1
  # DELETE /survey_items/1.json
  def destroy
    @survey_item.destroy
    respond_to do |format|
      format.html { redirect_to @survey_item.survey, notice: 'Survey item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = authed_user.find_editable_survey_from_surveypermalink(params[:survey_id])
      raise ActiveRecord::RecordNotFound unless @survey
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_item
      @survey_item = @survey.survey_items.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_item_params
      params.require(:survey_item).permit(:headline, :description, :thumbnail_url)
    end
end
