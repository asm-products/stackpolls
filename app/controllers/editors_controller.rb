class EditorsController < ApplicationController
  before_filter :enforce_auth, except: :accept
  before_action :set_survey, only:  [:accept, :invite]
  before_action :set_survey_from_auth, except:  [:accept, :invite]
  before_action :set_editor, only: [:show, :accept, :invite, :edit, :update, :destroy]

  # GET /editors
  # GET /editors.json
  def index
    @editors = @survey.editors.all
  end

  # GET /editors/1/accept
  # GET /editors/1/accept.json
  def invite
    unless @editor.accepted_at.blank?
      redirect_to [@editor.survey, @editor], notice: 'This invitation to be an editor has already been accepted.'
      return
    end
  end

  # PATCH/PUT /editors/1/accept
  # PATCH/PUT /editors/1/accept.json
  def accept
    @editor.editing_user = authed_user
    @editor.accepted = true
    
    respond_to do |format|
      if @editor.save
        format.html { redirect_to [@editor.survey, @editor], notice: 'Editor invite was successfully accepted.' }
        format.json { render :show, status: :ok, location: [@editor.survey, @editor] }
      else
        format.html { render :edit }
        format.json { render json: @editor.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /editors/1
  # GET /editors/1.json
  def show
  end

  # GET /editors/new
  def new
    @editor = @survey.editors.build
    @editor.inviter = authed_user
  end

  # GET /editors/1/edit
  def edit
  end

  # POST /editors
  # POST /editors.json
  def create
    @editor = @survey.editors.build(editor_params)
    @editor.inviter = authed_user

    respond_to do |format|
      if @editor.save
        format.html { redirect_to [@editor.survey, @editor], notice: 'Editor was successfully created.' }
        format.json { render :show, status: :created, location: [@editor.survey, @editor] }
      else
        format.html { render :new }
        format.json { render json: @editor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /editors/1
  # PATCH/PUT /editors/1.json
  def update
    @editor.editing_user = auth_user
    
    respond_to do |format|
      if @editor.update(editor_params)
        format.html { redirect_to [@editor.survey, @editor], notice: 'Editor was successfully updated.' }
        format.json { render :show, status: :ok, location: [@editor.survey, @editor] }
      else
        format.html { render :edit }
        format.json { render json: @editor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editors/1
  # DELETE /editors/1.json
  def destroy
    @editor.destroy
    respond_to do |format|
      format.html { redirect_to survey_editors_url(@survey), notice: 'Editor was successfully removed.' }
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
    def set_editor
      @editor = @survey.editors.where(email:  (params[:id].gsub(/%2E/, '.')) ).first
      raise ActiveRecord::RecordNotFound unless @editor
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def editor_params
      params.require(:editor).permit(:email)
    end
end
