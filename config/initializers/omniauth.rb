Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '48c6aade1f31410073a2', '082d0e487cb89b7b521eace61eb18c3d08370ed3'
end