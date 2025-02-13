# ApplicationController is the base controller for all other controllers in the application.
# It includes common functionality such as user authentication and browser compatibility checks.
#
# @example
#   class SomeController < ApplicationController
#     # controller actions here
#   end
#
class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  before_action :authenticate_api_v1_user! # 🔥 Garante que a autenticação funciona para API

  private

  def current_user
    current_api_v1_user # 🔥 Certifica-se de que o Devise reconhece `current_user`
  end
end
