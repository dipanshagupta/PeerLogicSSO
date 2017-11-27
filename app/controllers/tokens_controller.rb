class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def getToken
    token = Token.new
    token.client_id = params[:clientid]
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    keysindb = Key.all
    if keysindb.size == 0
      newkey = Key.new
      newkey.key = Base64.encode64(cipher.random_key)
      newkey.initial_value = Base64.encode64(cipher.random_iv)
      newkey.save
    else
      oldkey = keysindb.reverse[0]
      cipher.key = Base64.decode64(oldkey.key)
      cipher.iv = Base64.decode64(oldkey.initial_value)
    end
    data = "confidential data"
    token.token = Base64.encode64(cipher.update(token.to_json) + cipher.final)
    render json: token
  end

  def validateToken
    token = Base64.decode64(params["token"])

    keysindb = Key.all
    decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    decipher.decrypt
    oldkey = keysindb.reverse[0]
    decipher.key = Base64.decode64(oldkey.key)
    decipher.iv = Base64.decode64(oldkey.initial_value)
    plain = decipher.update(token) + decipher.final
    puts plain
    res = ValidationResponse.new
    res.clientname = plain
    render json: res
  end
end
