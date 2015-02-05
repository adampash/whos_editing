socket = io()

addUser = ->
  socket.emit 'add user',
    name: 'bob'
    avatar: 'http://example.com/pic.png'
    id: 12321432

$('.edit_post').on 'click', ->
  editing $(@).data('post-id')

$('.stop_edit_post').on 'click', ->
  stopEditing $(@).data('post-id')

editing = (post_id) ->
  socket.emit 'editing',
    post_id: post_id

stopEditing = (post_id) ->
  socket.emit 'stop editing',
    post_id: post_id

socket.on 'editing', (data) ->
  console.log "user is editing", data

socket.on 'left', (data) ->
  console.log "user left", data

socket.on 'connect', addUser
