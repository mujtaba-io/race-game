from flask import Flask, render_template, request, redirect
from flask import jsonify
import traceback
import time



# Dictionary to store text data by URL
rooms: dict = {} # all game rooms




app = Flask(__name__)
app.config['SECRET_KEY'] = 'myfuckingsecurekeyhehe'  # Change this to a secure secret key


@app.route('/room/<path:pin>/', methods=['GET'])
def room_data(pin=''):
    print("room_data") ############################################
    reset_all_rooms() # TMP, IT ADDS FULL OVERHEAD PER REQUIEST #######
    if pin in rooms:
        return jsonify(rooms[pin])
    else:
        return jsonify({'error': 'Room not found.'})


@app.route('/setplayerdata/<path:pin>/', methods=['POST'])
def update_player_data(pin=''):
    print("update_player_data") ############################################
    reset_all_rooms() # TMP, IT ADDS FULL OVERHEAD PER REQUIEST #######
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
        player_name: str = request.json['name']
        player_data: dict = request.json['player_data']
        room_data: dict = request.json['room_data']

        print("Player name: ", player_name)

        if pin in rooms:
            rooms[pin]['players'][player_name] = player_data
            print("Player added to existing room.")
        else:
            rooms[pin] = room_data # SHOULD WE ADD PLAYER DATA OR IS IT ALREADY SENT WITH THE ROOM DATA ITSELF?
            # Anyway, I think initially player data should is empty by default,
            # so we will add player data here as well (or call it override?)
            rooms[pin]['players'][player_name] = player_data
    except:
        traceback.print_exc()

    return jsonify(rooms[pin])


@app.route('/changelevel/<path:pin>/', methods=['POST'])
def change_level(pin=''):
    try:
        new_level: dict = request.json['level']

        if pin in rooms:
            rooms[pin]['level'] = new_level
        else:
            return jsonify({'error': 'Room not found.'})
    except:
        traceback.print_exc()

    return jsonify(rooms[pin])


@app.route('/leaveroom/<path:pin>/', methods=['POST'])
def leave_room(pin=''):
    try:
        player_name: str = request.json['name']
        if pin in rooms:
            if player_name in rooms[pin]['players']:
                del rooms[pin]['players'][player_name]
                print("Player left the room.")
            else:
                return jsonify({'error': 'Player not found in the room.'})
        else:
            return jsonify({'error': 'Room not found.'})
    except:
        traceback.print_exc()
    return jsonify(rooms[pin])


@app.route('/alldata', methods=['GET'])
def all_data():
    return jsonify(rooms)



def reset_room(pin: str):
    if pin in rooms:
        # Iterate over a list of player keys to avoid runtime error
        for player in list(rooms[pin]['players'].keys()):
            # If player's 'timestamp' is 12 seconds older than current time, remove player
            if time.time() - rooms[pin]['players'][player]['timestamp'] > 12:
                if player == rooms[pin]['admin']:
                    rooms[pin]['admin'] = ''
                del rooms[pin]['players'][player]
                print("Player removed.")

        if len(rooms[pin]['players']) == 0:
            del rooms[pin]
            print("Room deleted.")
        elif rooms[pin]['admin'] == '':
            rooms[pin]['admin'] = list(rooms[pin]['players'].keys())[0]
            print("Admin changed.")




def reset_all_rooms():
    for pin in rooms:
        reset_room(pin)



if __name__ == '__main__':
    app.run(debug=True, port=7860)
