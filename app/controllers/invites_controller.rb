class InvitesController < ApplicationController
  before_filter :enforce_auth, except: :show
  before_action :set_survey, only: :show
  before_action :set_survey_from_auth, except: :show
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  # GET /invites
  # GET /invites.json
  def index
    @invites = @survey.invites.all
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
    # If not logged in, or not an owned survey...
    if !auth_hash || !authed_user.find_editable_survey_from_surveypermalink(params[:survey_id])
      redirect_to new_survey_response_url(@survey, { invite: params[:id] })
      return
    end
    
  end

  # GET /invites/new
  def new
    @invite = @survey.invites.build
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  # POST /invites.json
  def create
    @invite = @survey.invites.build(invite_params)

    respond_to do |format|
      if @invite.save
        format.html { redirect_to [@invite.survey, @invite], notice: 'Invite was successfully created.' }
        format.json { render :show, status: :created, location: [@invite.survey, @invite] }
      else
        format.html { render :new }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    respond_to do |format|
      if @invite.update(invite_params)
        format.html { redirect_to [@invite.survey, @invite], notice: 'Invite was successfully updated.' }
        format.json { render :show, status: :ok, location: [@invite.survey, @invite] }
      else
        format.html { render :edit }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to invites_url, notice: 'Invite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_survey_from_auth
      @survey = authed_user.find_editable_survey_from_surveypermalink(params[:survey_id])
      raise ActiveRecord::RecordNotFound unless @survey
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.where(permalink: params[:survey_id]).first
      raise ActiveRecord::RecordNotFound unless @survey
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = @survey.invites.where(token: params[:id]).first
      raise ActiveRecord::RecordNotFound unless @invite
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:email, :name)
    end
end
