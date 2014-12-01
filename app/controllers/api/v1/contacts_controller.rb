class Api::V1::ContactsController < Api::ApiController
  doorkeeper_for :all  #this will require access token for all actions

  def index
    contacts = Contact.all
    respond_with(contacts)
  end
end
