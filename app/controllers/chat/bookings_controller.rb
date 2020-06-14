# Replace chatrooms_controller
class Chat::BookingsController < ApplicationController
  def show
    @booking = Booking.find(params[:id])
    @chatroom = @booking.chatroom
    @message = Message.new

    redirect_to root_path, notice: "Chatroom not found." unless belongs_to_user?
    # only owner/renter have access to the chatroom
  end

  def belongs_to_user?
    @booking.car.user == current_user || current_user.booking_ids.include?(@booking.id)
    # car owner or renter
  end
end
