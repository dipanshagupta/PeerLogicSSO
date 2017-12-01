OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '397781399587-8a6nh966h0dlml51u38o2n2r1v3nb3oe.apps.googleusercontent.com', '-xTci0Nj_TAAHs1pV5-votax', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end