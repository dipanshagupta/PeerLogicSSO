class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def getToken
    tokenjson = TokenJson.new
    tokenjson.clientkey = params["clientkey"]
    tokenjson.clientid = Client.where("key = ?", tokenjson.clientkey).first.id

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
    tokenResponse = GetTokenResponse.new
    tokenResponse.client_id = params[:clientkey]
    tokenResponse.token = Base64.encode64(cipher.update(tokenjson.to_json) + cipher.final)
    render json: tokenResponse
  end

  def validateToken
    token = Base64.decode64(params["token"])

    decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    decipher.decrypt

    keysindb = Key.all
    oldkey = keysindb.reverse[0]
    decipher.key = Base64.decode64(oldkey.key)
    decipher.iv = Base64.decode64(oldkey.initial_value)
    plain = decipher.update(token) + decipher.final
    tokenjson = JSON.parse(plain, object_class: TokenJson)
    client = Client.find(tokenjson.clientid)
    apis = client.apis
    res = ValidationResponse.new
    res.success = false
    apis.each do |x|
      if(x.name == params[:api])
        res.success = true
      end
    end
    res.clientname = client.name
    render json: res
  end
end
