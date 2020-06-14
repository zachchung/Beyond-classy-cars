// RECEIVE BROADCAST & insertAdjacentHTML
// Setup subscription (#message)
import consumer from "./consumer"; // needed for actioncable

const initChatroomCable = () => {
  const messagesContainer = document.querySelector('#messages');
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId; // from chatrooms/show.html

    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, { // to chatroom_channel.rb
      // When a broadcast is received
      received(data) {
        // data => <div class="message-container" id="message-15"> <i class="author"> <span>Papillard</span> <small>Mon Jun  8 at 12:01PM</small> </i> <p>hi</p> </div>
        console.log(data);
        messagesContainer.insertAdjacentHTML('beforeend', data); // called when data is broadcast in the cable
      }
    });
  }
}

export { initChatroomCable };



// const initChatroomCable = () => {
//   const messagesContainer = document.querySelector('#messages');
//   if (messagesContainer) {
//     const id = messagesContainer.dataset.chatroomId;

//     id.addEventListener("submit", (event) => {
//       const data = render_to_string(partial: "messages/message", locals: { message: @message })
//       id.insertAdjacentHTML('beforeend', data);
//     });
//   };
// }
