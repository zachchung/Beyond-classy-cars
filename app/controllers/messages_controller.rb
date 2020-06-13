class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      redirect_to chatroom_path(@chatroom, anchor: "message-#{@message.id}")
      # when got new msg, ask channel to SEND BROADCAST (so no need to refresh the page to see the msg)
      ChatroomChannel.broadcast_to(@chatroom,
        render_to_string(partial: "messages/message", locals: { message: @message })
      ) # can't render twice in controller. Use render_to_string instead (eg. map- render_to_string "info-windows).
    else
      render "chatrooms/show" # the form is from chatrooms_controller#show
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
