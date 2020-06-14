# REPLACE messages_controller
class Chat::MessagesController < ApplicationController
  # POST   /chat/bookings/:booking_id/messages
  def create
    @booking = Booking.find(params[:booking_id])
    @chatroom = @booking.chatroom
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      # when got new msg, ask channel to SEND BROADCAST (so no need to refresh the page to see the msg)
      ChatroomChannel.broadcast_to(@chatroom,
        render_to_string(partial: "messages/message", locals: { message: @message })
      ) # can't render twice in controller. Use render_to_string instead (eg. map- render_to_string "info-windows).
      redirect_to chat_booking_path(@booking, anchor: "message-#{@message.id}")
    else
      render "chat/bookings/show" # the form is from chat::bookings_controller#show
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
