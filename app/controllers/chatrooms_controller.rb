class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    redirect_to root_path, notice: "Chatroom is not found." unless belongs_to_user?
  end

  def belongs_to_user?
    @chatroom = Chatroom.find(params[:id])
    @booking = Booking.find(@chatroom.index)
    @booking.car.user == current_user || current_user.booking_ids.include?(@booking.id) # ??????????
  end
end
