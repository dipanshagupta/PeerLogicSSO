json.extract! client, :id, :key, :name, :user_id, :created_at, :updated_at
json.url client_url(client, format: :json)
