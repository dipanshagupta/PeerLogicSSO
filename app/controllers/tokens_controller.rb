class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def getToken
    tokenResponse = GetTokenResponse.new
    tokenjson = TokenJson.new
    tokenjson.clientkey = params["clientkey"]
    if tokenjson.clientkey.nil?
      tokenResponse.message = "CLIENT_NOT_RECOGNISED"
      tokenResponse.status = 401
    else
      clients = Client.where("key = ?", tokenjson.clientkey)
      if clients.nil?
        tokenResponse.message = "CLIENT_NOT_RECOGNISED"
        tokenResponse.status = 401
      else
      tokenjson.clientid = clients.first.id
      tokenjson.timestamp = (Time.now.to_f * 1000).to_i
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.encrypt
      keysindb = Key.all
      if keysindb.size == 0
        newkey = Key.new
        newkey.key = Base64.encode64(cipher.random_key)
        newkey.initial_value = Base64.encode64(cipher.random_iv)
        newkey.ttl = 86400000
        newkey.save
      else
        oldkey = keysindb.reverse[0]
        cipher.key = Base64.decode64(oldkey.key)
        cipher.iv = Base64.decode64(oldkey.initial_value)
      end
      tokenResponse.client_id = params[:clientkey]
      begin
        plain = Base64.encode64(cipher.update(tokenjson.to_json) + cipher.final)
        plain = plain.gsub("\n", "")
        tokenResponse.token = plain
        tokenResponse.message = "OK";
        tokenResponse.status = 200
      rescue
        tokenResponse.message = "SSO_ENCRYPTION_ERROR";
        tokenResponse.status = 500;
      end
      end
    end
    render json: tokenResponse
  end

  def validateToken
    token = Base64.decode64(params["token"])
    res = ValidationResponse.new
    if(token.nil?)
      res.status = 401
      res.message = "CLIENT_NOT_RECOGNISED"
    else
      decipher = OpenSSL::Cipher::AES.new(128, :CBC)
      decipher.decrypt
      keysindb = Key.all
      oldkey = keysindb.reverse[0]
      flag = 0
      if(oldkey.nil? || Base64.decode64(oldkey.key).nil? || Base64.decode64(oldkey.initial_value).nil?)
        res.status = 500
        res.message = "SSO_DECRYPTION_KEY_NOT_FOUND"
      else
      decipher.key = Base64.decode64(oldkey.key)
      decipher.iv = Base64.decode64(oldkey.initial_value)
      begin
        plain = decipher.update(token) + decipher.final
        tokenjson = JSON.parse(plain, object_class: OpenStruct)
      rescue
        res.status = 500
        res.message = "SSO_DECRYPTION_ERROR"
        flag = 1
      end
      if flag == 0
      res.status = 401
      if((Time.now.to_f * 1000).to_i > tokenjson.timestamp + oldkey.ttl)
        res.message = "TOKEN_EXPIRED"
      else
        client = Client.find(tokenjson.clientid)
        if(client.nil?)
          res.message = "CLIENT_NOT_RECOGNISED"
        else
          apis = client.apis
          apis.each do |x|
            if(x.name == params[:api])
              res.status = 200
              res.message = "OK"
              break
            end
          end
          if(res.status == 401)
            res.message = "CLIENT_UNAUTHORIZED"
          end
          res.clientname = client.name

        end
      end
      end
      end
    end
    render json: res
  end
end
