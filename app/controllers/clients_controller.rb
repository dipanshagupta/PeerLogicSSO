class ClientsController < ApplicationController

  include ApplicationHelper

  before_action :set_client, only: [:show, :edit, :update, :destroy]

  before_action :checkLogIn

  # GET /clients
  # GET /clients.json
  def index
    if isAdmin?
      @clients = Client.all
    else
      @clients = Client.where(user_id: @current_user.id)
    end
  end

  def checkLogIn
    if !isLoggedIn?
      redirect_to login_path
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  def requestKey
    client = Client.find(params[:id])
    client.requested = true
    if client.save
    end
    redirect_to clients_path
  end

  def generateKey
    client = Client.find(params[:id])
    client.key = SecureRandom.base64(32)
    client.requested = false
    client.hasKey = true
    client.save
    redirect_to clients_path
  end

  def enableApisForm
    @client = Client.find(params[:id])
    @apis = Api.all
  end

  def enableApis
    @client = Client.find(params[:id])
    @apis = Api.all
  end

  def revokeKey
    client = Client.find(params[:id])
    client.key = ""
    client.requested = false
    client.hasKey = false
    client.save
    redirect_to clients_path
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    @client.user_id = @current_user.id
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:key, :name, :user_id)
    end
end
