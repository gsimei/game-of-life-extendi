# ApplicationController is the base controller for all other controllers in the application.
# It includes common functionality such as user authentication and browser compatibility checks.
#
# @example
#   class SomeController < ApplicationController
#     # controller actions here
#   end
#
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # This filter will run before any action in the controllers that inherit from ApplicationController.
  # It ensures that the user is authenticated before accessing any controller actions.
  #
  # @return [void]
  before_action :authenticate_user!
end
