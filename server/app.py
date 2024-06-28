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


@app.route('/join/<path:pin>/', methods=['POST'])
def join_room(pin=''):
    try:
        player_name: str = request.json['player_name'] # get player info from post request

        if pin in rooms: # if room exists
            if rooms[pin]['game']['state'] == 'in_game': # if in game
                if player_name in rooms[pin]['players']: # if player already there
                    return jsonify(rooms[pin]) # send new room state to him
                else: # if player is new arrival
                    return jsonify({'error': 'Race is racing, so wait...'})
            else: # if not in game (means, if in lobby)
                rooms[pin]['players'][player_name]= {} # join player to room
                # assign spawn_point to player as the current length of players
                rooms[pin]['players'][player_name]['spawn_point'] = len(rooms[pin]['players']) - 1
                #   TODO: IF SOMEONE LEAVES, THEN SPAWN POINTS WILL BE MESSED UP
                return jsonify(rooms[pin]) # send new room state to him
        else:
            create_room(pin, player_name)
            return jsonify(rooms[pin]) # send new room state to him
    except:
        traceback.print_exc()


# TODO: UPDATE THIS FUNCTION AS JOINING IS NOW HANDLED BY join_room()
# updates player state and returns the updated room state
@app.route('/room/<path:pin>/', methods=['GET', 'POST'])
def update_player_state(pin=''):
    try:
        # if it is network plaayer requesting new game state, give him
        if request.method == 'GET':
            return jsonify(rooms[pin])

        # else if it is human player aiming to push his state to server
        player_name: str = request.json['player_name'] # get player info from post request
        player_state: dict = request.json['player_state']

        if pin in rooms: # if room exists
            if rooms[pin]['game']['state'] == 'in_game': # if in game
                if player_name in rooms[pin]['players']: # if player already there
                    rooms[pin]['players'][player_name] = player_state # update player state
                    return jsonify(rooms[pin]) # send new room state to him
                else: # if player is new arrival
                    return jsonify({'error': 'Race is racing, so wait...'})
                    # REMOVE THIS CONSTRAINT. LET PEOPLE JOIN MID-RACE...
            else: # if not in game (means, if in lobby)
                rooms[pin]['players'][player_name]= player_state # update player state
                return jsonify(rooms[pin]) # send new room state to him
        else:
            create_room(pin, player_name, player_state)
            return jsonify(rooms[pin]) # send new room state to him
    except:
        traceback.print_exc()


def create_room(pin:str, initial_player_name:str):
    rooms[pin] = {
        'players': {
            initial_player_name: {},
        },
        'game': {
            'map': '',
            'state': 'in_lobby',
            'admin': initial_player_name,
            'time_left': '',
            'total_laps': 2,
        }
    }


# updates room state and returns the updated room state
# only room admin can update room state
@app.route('/start/<path:pin>/', methods=['POST'])
def start_game(pin=''):
    who_started: str = request.json['player_name']
    print(who_started)
    if who_started == rooms[pin]['game']['admin']:
        rooms[pin]['game']['state'] = 'in_game'
        return jsonify(rooms[pin])
    else:
        return jsonify({'error': 'Only admin can start the game'})




"""
# get global internet time to sync all clients to start rce at the same time
import ntplib
import time

def get_ntp_time(server="pool.ntp.org"):
  try:
    client = ntplib.NTPClient()
    response = client.request(server)
  except ntplib.NTPException as e:
    raise  # Re-raise the exception

  # Convert NTP timestamp to seconds since epoch
  return response.tx_time - time.timezone
"""


if __name__ == '__main__':
    app.run(debug=True, port=7860)
