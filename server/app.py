from flask import Flask, render_template, request, redirect
from flask import jsonify

app = Flask(__name__)
app.config['SECRET_KEY'] = 'myfuckingsecurekeyhehe'  # Change this to a secure secret key

# Dictionary to store text data by URL
rooms: dict = {} # all game rooms


# API
import traceback


@app.route('/updateplayerdata/<path:pin>/', methods=['POST'])
def update_player_data(pin=''):
    try:
        # else if it is human player aiming to push his state to server
        player_name: str = request.json['name'] # get player info from post request
        player_data: dict = request.json['data']

        if pin in rooms: # if room exists
            rooms[pin]['players'][player_name] = player_data
        else:
            return jsonify({'error': 'Room not found.'})
    except:
        traceback.print_exc()

    return jsonify(rooms[pin])



@app.route('/startgame/<path:pin>/', methods=['POST'])
def start_game(pin=''):
    try:
        print("A")
        player_name = request.json["name"]
        print("B: "+str(player_name))
        if pin in rooms:
            if player_name == rooms[pin]['admin']:
                rooms[pin]['state'] = 'in_game'
                print("C")
        else:
            return jsonify({'error': 'Room not found.'})
    except:
        traceback.print_exc()

    return jsonify(rooms[pin])




@app.route('/joinroom/<path:pin>/', methods=['POST'])
def join_room(pin=''):
    print("Attempting to join room")
    try:
        room_data: dict = request.json['data']
        player_name: str = list(room_data['players'].keys())[0]

        print("Player name: ", player_name)

        if pin in rooms:
            rooms[pin]['players'][player_name] = room_data['players'][player_name]
            print("Player added to existing room.")
        else:
            rooms[pin] = room_data
            rooms[pin]['admin'] = player_name # admin is who created the room
            rooms[pin]['state'] = 'in_lobby'
            rooms[pin]['pin'] = pin
    except:
        traceback.print_exc()

    return jsonify(rooms[pin])


if __name__ == '__main__':
    app.run(debug=True, port=7860)
