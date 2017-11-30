class KeysController < ApplicationController
  before_action :set_key, only: [:show, :edit, :update, :destroy]

  # GET /keys
  # GET /keys.json
  def index
    @keys = Key.all
  end

  # GET /keys/1
  # GET /keys/1.json
  def show
  end

  # GET /keys/new
  def new
    @key = Key.new
  end

  # GET /keys/1/edit
  def edit
  end

  # POST /keys
  # POST /keys.json
  def create
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    newkey = Key.new
    newkey.key = Base64.encode64(cipher.random_key)
    newkey.initial_value = Base64.encode64(cipher.random_iv)
    newkey.ttl = 86400000
    newkey.save

    respond_to do |format|
      if newkey.save
        format.html { redirect_to newkey, notice: 'Key was successfully created.' }
        format.json { render :show, status: :created, location: @key }
      else
        format.html { render :new }
        format.json { render json: newkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /keys/1
  # PATCH/PUT /keys/1.json
  def update
    respond_to do |format|
      if @key.update(key_params)
        format.html { redirect_to @key, notice: 'Key was successfully updated.' }
        format.json { render :show, status: :ok, location: @key }
      else
        format.html { render :edit }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keys/1
  # DELETE /keys/1.json
  def destroy
    @key.destroy
    respond_to do |format|
      format.html { redirect_to keys_url, notice: 'Key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_key
      @key = Key.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def key_params
      params.require(:key).permit(:ttl)
    end
end
