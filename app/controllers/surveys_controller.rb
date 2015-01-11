class SurveysController < ApplicationController
  before_filter :enforce_auth, except: :show
  before_action :set_survey_from_auth, only: [:edit, :update, :destroy]
  before_action :set_survey, only: :show

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = authed_user.surveys.all + Survey.where(id: authed_user.editors.map(&:survey_id)).all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    # If not logged in, or not an owned survey...
    if !auth_hash || !authed_user.can_edit_surveypermalink?(params[:id])
      redirect_to [:new, @survey, :response]
      return
    end
  end

  # GET /surveys/new
  def new
    @survey = authed_user.surveys.build
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = authed_user.surveys.build(survey_params)

    respond_to do |format|
      if @survey.save
        format.html { redirect_to [:edit, @survey], notice: 'Survey was successfully created.' }
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_from_auth
      @survey = authed_user.find_editable_survey_from_surveypermalink(params[:id])
      raise ActiveRecord::RecordNotFound unless @survey
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.where(permalink: params[:id]).first
      raise ActiveRecord::RecordNotFound unless @survey
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:permalink, :required_google_apps_domain_login, :title, :headline, :subheader, :thanks_headline, :thanks_subheader, :thanks_continue_url, :invite_required)
    end
end
