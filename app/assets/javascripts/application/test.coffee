dispatcher = new WebSocketRails('localhost:3000/websocket')

$ ->
    $('#load').click ->
        id = $('#id').val()
        dispatcher.trigger('clans.load', id);
        console.log 'Dispatching clans.load with id ' + id

        channel = dispatcher.subscribe('clans.'+id);
        channel.bind 'update', (message) ->
            console.log message
            for pid, data of message.members
                channel = dispatcher.subscribe('players.'+pid);
                channel.bind 'update', (pmessage) ->
                    console.log pmessage
