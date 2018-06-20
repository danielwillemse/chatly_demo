# Chatly

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## How to recreate this app

  Create your app:
  ```
  ~ % mix phx.new chatly --no-ecto
    Fetch and install dependencies? [Yn] Y
  ```

  ```
  ~ % mix phx.gen.channel Room
  ```

  Add jquery to package.json:
  ```
  "jquery": ">= 2.1"
  ```

  Replace content in /lib/chatly_web/templates/page/index.html.eex:
  ```
  <div id="list" class="row"></div>

  <div class="row form-group">
    <div class="col-xs-3">
      <input type="text" id="name" class="form-control" placeholder="Name">
    </div>
    <div class="col-xs-9">
      <input type="text" id="message" class="form-control" placeholder="Message">
    </div>
  </div>
  ```

  Add to /assets/css/app.css:
  ```
  #list {
    border: 1px solid black;
    height: 300px;
    padding: 5px;
    overflow: scroll;
    margin-bottom: 30px;
  }
  ```

  Add to /lib/chatly_web/channels/user_socket.ex:
  ```
  channel "room:*", ChatlyWeb.RoomChannel
  ```

  Add to /assets/js/app.js:
  ```
  import socket from "./socket"
  import $ from "jquery"

  let channel = socket.channel("room:lobby", {})
  let list = $('#list')
  let name = $('#name')
  let message = $('#message')

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on('shout', payload => {
    list.append(`<b>${payload.name}:</b> ${payload.message}<br/>`);
  });

  message.on('keypress', event => {
    if (event.keyCode == 13) {
      channel.push('shout', {
        name: name.val(),
        message: message.val()
      })
      message.val('')
    }
  })
  ```

  Add to /lib/chatly_web/channels/room_channel.ex
  ```
  def handle_info(:after_join, socket) do
    push(socket, "shout", %{name: "Chatly", message: "Welcome!"})
    {:noreply, socket}
  end
  ```

  Start your server!
  ```
  ~ % mix phx.server
  ```

  Go to localhost:4000
