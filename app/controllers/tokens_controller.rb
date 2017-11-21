class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token
  def getToken

    token = Token.new
    token.client_id = params[:clientid]
    token.token = "abc"
    render json: token
  end

  def validateToken
    res = ValidationResponse.new
    res.clientid = "abc"
    render json: res
  end
end
