class ResponsesController < ApplicationController
  before_filter :enforce_auth, except: [:new, :create, :thanks]
  before_action :set_survey, only: [:new, :create, :thanks]
  before_action :set_survey_from_auth, except: [:new, :create, :thanks]
  before_action :set_response, only: [:show, :thanks, :edit, :update, :destroy]

  # GET /responses
  # GET /responses.json
  def index
    @responses = @survey.responses.all
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
  end

  # GET /responses/new
  def new
    # Sorry, need a valid invite code for some
    if @survey.invite_required && params[:invite].blank?
      render text: "Sorry, this link requires an invite code in the URL.  Please contact us if you think this is our mistake!", status: 401
      return
    end
    if @survey.invite_required && !@survey.invitetoken_can_respond?(params[:invite])
      render text: "Sorry, this invite code is not (or at least, no longer) valid.  Please contact us if you think this is our mistake!", status: 401
      return
    end
    if !@survey.required_google_apps_domain_login.blank? && !authed_user
      redirect_to "/sessions/google/new?next=#{CGI.escape(request.url)}"
      return
    end
    if !@survey.required_google_apps_domain_login.blank? && authed_user && !authed_user.email.to_s.downcase.ends_with?("@#{@survey.required_google_apps_domain_login}".downcase)
      render text: "Sorry, a Google login with a whitelisted email address is required.  Please contact us if you think this is our mistake!", status: 401
      return
    end
    
    @response = @survey.responses.build
    @response.build_item_ranks_from_survey_if_needed
    
    # Autofill on invite
    unless params[:invite].blank?
      invite = @survey.invites.where(token: params[:invite]).first
      if invite
        @response.invite = invite
        @response.autofill_name_and_email_from_invite
      end
    end
    
    # Autofill on auth if not on invite
    if @response.invite.nil? && authed_user
      @response.autofill_user_name_and_email_from_user(authed_user)
    end
    
    # Set user regardless, if there is one
    if @response.user.nil? && authed_user
      @response.user = authed_user
    end
  end

  # GET /responses/1/thanks
  def thanks
  end

  # GET /responses/1/edit
  def edit
  end

  # POST /responses
  # POST /responses.json
  def create
    # Sorry, need a valid invite code for some
    if @survey.invite_required && params[:invite].blank?
      render text: "Sorry, this link requires an invite code in the URL.  Please contact us if you think this is our mistake!", status: 401
      return
    end
    if @survey.invite_required && !@survey.invitetoken_can_respond?(params[:invite])
      render text: "Sorry, this invite code is not (or at least, no longer) valid.  Please contact us if you think this is our mistake!", status: 401
      return
    end
    if !@survey.required_google_apps_domain_login.blank? && !authed_user
      redirect_to "/sessions/google/new?next=#{CGI.escape(request.url)}"
      return
    end
    if !@survey.required_google_apps_domain_login.blank? && authed_user && !authed_user.email.to_s.downcase.ends_with?("@#{@survey.required_google_apps_domain_login}".downcase)
      render text: "Sorry, a Google login with a whitelisted email address is required.  Please contact us if you think this is our mistake!", status: 401
      return
    end
    
    @response = @survey.responses.build(response_params)
    @response.fixme_hack_ensure_item_ranks_belong_to_me
    
    # Set on invite
    unless params[:invite].blank?
      invite = @survey.invites.where(token: params[:invite]).first
      if invite
        @response.invite = invite
      end
    end
    
    # Set user regardless, if there is one
    if @response.user.nil? && authed_user
      @response.user = authed_user
    end
    
    respond_to do |format|
      if @response.save
        format.html { redirect_to [:thanks, @response.survey, @response], notice: 'Response was successfully recorded.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to responses_url, notice: 'Response was successfully destroyed.' }
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
    def set_response
      @response = @survey.responses.find(params[:id])
      raise ActiveRecord::RecordNotFound unless @response
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.require(:response).permit(:email, :name, :comments, :invite, item_ranks_attributes: [ :rank, :survey_item_id ])
    end
end
