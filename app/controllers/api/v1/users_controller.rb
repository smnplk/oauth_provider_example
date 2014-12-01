class Api::V1::UsersController < Api::ApiController
  doorkeeper_for :all

  def me
    respond_with(current_user)
  end

end
