class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    # parmas => { channel: "ChatroomChannel", id: id }
    chatroom = Chatroom.find(params[:id]) # from chatroom_channel.js
    stream_for chatroom # ?

    # rails c: ChatroomChannel.broadcast_to(Chatroom.first, "Hello") (not work...need to setup redis)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
