from flask import Flask, render_template, request, redirect
from flask import jsonify

app = Flask(__name__)
app.config['SECRET_KEY'] = 'myfuckingsecurekeyhehe'  # Change this to a secure secret key

# Dictionary to store text data by URL
rooms: dict = {} # all game rooms

"""
rooms = {
    'room_pin': {
        'players': {
            'player_name': {
                ...state...
            },
            ...
        },
        'game': {
            'map': x,
            'state': 'in_game/ready/in_lobby',
            'admin": '',
            ...
        }
    }
    ...
}
"""

# API
import traceback

@app.route('/room/<path:pin>/', methods=['POST'])
def update_player_state(pin=''):
    try:
        player_name: str = request.json['player_name'] # get player info from post request
        player_state: dict = {}

        if pin in rooms: # if room exists
            if rooms[pin]['game']['state'] == 'in_game': # if in game
                if player_name in rooms[pin]['players']: # if player already there
                    rooms[pin]['players'][player_name] = player_state # update player state
                    return jsonify(rooms[pin]) # send new room state to him
                else: # if player is new arrival
                    return jsonify({'error': 'Race is racing, so wait...'})
            else: # if not in game (means, if in lobby)
                rooms[pin]['players'][player_name]= player_state # update player state
                return jsonify(rooms[pin]) # send new room state to him
        else:
            create_room(pin, player_name, player_state)
            return jsonify(rooms[pin]) # send new room state to him
    except:
        traceback.print_exc()


def create_room(pin:str, initial_player_name:str, initial_player_state):
    rooms[pin] = {
        'players': {
            initial_player_name: initial_player_state,
        },
        'game': {
            'map': '',
            'state': 'in_lobby',
            'admin': initial_player_name,
            'time_left': '',
        }
    }


@app.route('/start/<path:pin>/', methods=['POST'])
def start_game(pin=''):
    who_started: str = request.json['player_name']
    print(who_started)
    if who_started == rooms[pin]['game']['admin']:
        rooms[pin]['game']['state'] = 'in_game'
        print(rooms[pin]['game']['state'])
        return jsonify(rooms[pin])
    else:
        return jsonify({'error': 'Only admin can start the game'})


if __name__ == '__main__':
    app.run(debug=True, port=7860)
