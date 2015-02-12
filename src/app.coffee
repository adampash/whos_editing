express = require 'express'
app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server)
port = process.env.port || 3001

server.listen port, ->
  console.log "Server listening at port %d", port

app.use(express.static("#{__dirname}/public"))


# socket channels/rooms
posts = {}
users = {}
user_ids = []

io.on 'connection', (socket) ->
  console.log 'user connected'

  # add user to the socket
  socket.on 'add user', (data) ->
    console.log data
    socket.user = data
    users[socket.user.id] = socket.user
    user_ids.push socket.user.id
    console.log user_ids
    console.log users

  # when the client opens a post to edit
  socket.on 'editing', (data) ->
    console.log "#{socket.user.name} is editing #{data.post_id}"
    socket.join(data.post_id)
    unless posts[data.post_id]?
      posts[data.post_id] = []
    posts[data.post_id].push socket.user
    console.log posts[data.post_id]
    # tell the client to execute 'editing'
    socket.in(data.post_id).emit 'editing',
      post: data.post_id
      user: socket.user

  # when the client stops editing a post
  socket.on 'stop editing', (data) ->
    console.log "#{socket.user.name} is no longer editing #{data.post_id}"
    unless posts[data.post_id]?
      posts[data.post_id] = []
    posts[data.post_id].splice(posts[data.post_id].indexOf(socket.user), 1)
    console.log posts[data.post_id]
    # tell the client someone left
    console.log 'emitting left event'
    socket.to(data.post_id).emit 'left',
      post: data.post_id
      user: socket.user

  # when the user disconnects
  socket.on 'disconnect', (data) ->
    if socket.user?
      console.log "user #{socket.user.id} disconnected"
      user_ids.splice(user_ids.indexOf(socket.user.id), 1)
      console.log user_ids
      delete users[socket.user.id] unless socket.user.id in user_ids
      delete posts[socket.user]
    console.log users
    console.log posts
    # tell the room the client left
    # socket.broadcast.emit 'user left',
      # username: socket.username
      # post: data
