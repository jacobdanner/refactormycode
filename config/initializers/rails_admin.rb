RailsAdmin.authenticate_with do
  redirect_to root_path unless (current_user and current_user.try(:admin?))
end
# RailsAdmin.config do |config|
#   config.included_models = [Code, Refactor, User]
# end
