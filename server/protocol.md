

protocol for http based sync of data between devices


2 paths, upload and download.


x_label:
    human_player uploads HIS data to server.
    network_player downloads HIS data from server.


all players listen for glboal room state:
    if state=in-game: start race at START time
        end race at END time & x_label.
    if state=in-lobby:






on-game-open:
    goto start


start:
    enter room pin
    enter username
    trigger join-room-button


on-join-room-button-pressed:
    take room pin
    take username
    request server awaits response {
        if success: success-join-lobby
        if error: trigger goto-start
    }


success-join-lobby:
    updates room-state by trigger keep-alive-requests to server

    if room-state:admin is THIS player:
        can-trigger start-game-button


on-start-game-button-pressed:
    updates room-state by local-means







































all players listen to global_room_state and based on its values, they act locally.

human controllers always send HIS data to server, and ignore HIS data coming from server (as its outdated).

network controllers always take HIS data from server, and act according to it and NEVER SEND HIS data back to server.

ALL requests result in player getting updated state from server.

by 2 streams, I mean: requesting always updates server of OUR state
respnse always updates US of of all others' states