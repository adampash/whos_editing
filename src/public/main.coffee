socket = io()

socket.emit 'add user',
  name: 'bob'
  avatar: 'http://example.com/pic.png'
  id: 12321432

socket.emit 'editing',
  post_id: '12321382'

socket.on 'editing', (data) ->
  console.log "user joined", data

socket.on 'left', (data) ->
  console.log "user left", data
