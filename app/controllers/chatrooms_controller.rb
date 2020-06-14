class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    redirect_to root_path, notice: "Chatroom not found." unless belongs_to_user?
    # only owner/renter have access to the chatroom
  end

  def belongs_to_user?
    @chatroom = Chatroom.find(params[:id])
    @booking = Booking.find(@chatroom.index) # chatroom index = booking id
    @booking.car.user == current_user || current_user.booking_ids.include?(@booking.id)
    # car owner or renter
  end
end
