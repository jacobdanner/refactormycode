Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'yorzi', 'b07bf75193787c3e305f24123266942b'
end