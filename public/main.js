// Generated by CoffeeScript 1.8.0
(function() {
  var addUser, editing, socket, stopEditing;

  socket = io();

  addUser = function() {
    return socket.emit('add user', {
      name: 'bob',
      avatar: 'http://example.com/pic.png',
      id: 12321432
    });
  };

  $('.edit_post').on('click', function() {
    return editing($(this).data('post-id'));
  });

  $('.stop_edit_post').on('click', function() {
    return stopEditing($(this).data('post-id'));
  });

  editing = function(post_id) {
    return socket.emit('editing', {
      post_id: post_id
    });
  };

  stopEditing = function(post_id) {
    return socket.emit('stop editing', {
      post_id: post_id
    });
  };

  socket.on('editing', function(data) {
    return console.log("user is editing", data);
  });

  socket.on('left', function(data) {
    return console.log("user left", data);
  });

  socket.on('connect', addUser);

}).call(this);
