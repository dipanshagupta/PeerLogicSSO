class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token
  def getToken

    token = Token.new
    token.client_id = params[:clientid]

    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    keysindb = Key.all
    if keysindb.size == 0
      newkey = Key.new
      newkey.key = Base64.encode64(cipher.random_key).encode('utf-8')
      newkey.initial_value = Base64.encode64(cipher.random_iv).encode('utf-8')
      puts newkey
      newkey.save
    else
      oldkey = keysindb.reverse[0]
      cipher.key = oldkey.key
      cipher.iv = oldkey.initial_value
    end
    puts token.to_json
    data = "confidential data"
    token.token = Base64.encode64(cipher.update(token.to_json.to_s) + cipher.final).encode('utf-8')
    render json: token
  end

  def validateToken
    puts params["token"]
    token = Base64.decode64(params["token"]).encode('ascii-8bit')
    keysindb = Key.all
    decipher = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    oldkey = keysindb.reverse[0]
    puts oldkey.key
    decipher.key = Base64.decode64(oldkey.key).encode('ascii-8bit')
    decipher.iv = Base64.decode64(oldkey.initial_value).encode('ascii-8bit')
    plain = decipher.update(token) + decipher.final

    res = ValidationResponse.new
    res.clientid = plain
    render json: res
  end
end
