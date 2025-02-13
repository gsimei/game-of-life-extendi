# User represents a user of the application.
# It includes associations with game states and Devise modules for authentication.
#
# @!attribute [r] game_states
#   @return [ActiveRecord::Relation<GameState>] the game states associated with the user
class User < ApplicationRecord
  has_many :game_states, dependent: :destroy

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end
