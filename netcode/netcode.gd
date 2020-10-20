extends Node

var timer = 0
var playerupdatetimer = 0

const SERVER_IP = "192.168.1.10"
const PORT = 5000

var thisid

onready var vrscene = get_node("startup")

var nettestpanel
var nettestconnectbutton
var nettesthostbutton
var inputip
var currentipforlocal

onready var player = vrscene.get_node("playerroot")

onready var label

var updatelocationflag = true
var networksignalflag = false

var connected = false
var connectedashost = false


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server",self, "_connected_to_server")
	get_tree().connect("server_disconnected",self, "_disconnected_from_server")
	if vrscene:
		nettestpanel = vrscene.get_node("nettest3dpanel")
		if nettestpanel:
			nettestconnectbutton = nettestpanel.get_node( "Viewport/gui/join" )
			nettesthostbutton = nettestpanel.get_node( "Viewport/gui/host" )
			label = nettestpanel.get_node("Viewport/gui/log")
			inputip = nettestpanel.get_node("Viewport/gui/inip")
			currentipforlocal = nettestpanel.get_node("Viewport/gui/ip")
			currentipforlocal.text = "Current IP address for local hosting:\n" + str(IP.get_local_addresses()[0])
			if nettestconnectbutton:
				nettestconnectbutton.connect("pressed",self,"nettestconnectbuttonpressed")
			if nettesthostbutton:
				nettesthostbutton.connect("pressed",self,"nettesthostbuttonpressed")


func _process(delta):
	
	if connected == true:
		rpc("_update_client_position",player.rloc,player.lloc,player.hloc,thisid)
		playerupdatetimer = 0
	if connectedashost == true:
		for i in get_tree().get_network_connected_peers():
			rpc_id(i,"_update_client_position",player.rloc,player.lloc,player.hloc,1)

	playerupdatetimer += delta
	timer += delta

func _connected_to_server():
	# rpc("_test","this is a test from the client",id)
	loglbl('connected')
	connected = true
	var newclient = load("res://scenes/netplayer.tscn").instance()
	newclient.set_name(str(1))
	get_tree().get_root().add_child(newclient)

func _disconnected_from_server():
	# rpc("_test","this is a test from the client",id)
	connected = false
	get_tree().get_root().get_node(str(1)).queue_free()

func loglbl(text):
	label.text = text

remote func _test(thing):
	loglbl(thing)
	
remote func _testid(thing,inid):
	loglbl(thing)
	# rpc_id(1,"_test","this is a response to message ( "+thing+" )", id)

func nettestconnectbuttonpressed():
	var client = NetworkedMultiplayerENet.new()
	client.create_client(inputip.text, PORT)
	get_tree().network_peer = client
	if networksignalflag == false:
		networksignalflag = true
	thisid = get_tree().get_network_unique_id()

func nettesthostbuttonpressed():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(PORT,5)
	get_tree().network_peer = server
	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

func _client_connected(id):
	loglbl('Client ' + str(id) + ' connected to Server')
	var newclient = load("res://scenes/netplayer.tscn").instance()
	newclient.set_name(str(id))
	get_tree().get_root().add_child(newclient)
	connectedashost = true

func _client_disconnected(id):
	loglbl('Client ' + str(id) + ' disconnected from the Server')
	get_tree().get_root().get_node(str(id)).queue_free()


remote func _update_client_position(rloc,lloc,hloc,id):
	var tmpplayer = get_tree().get_root().get_node(str(id))
	tmpplayer.get_node("righthand").global_transform = rloc
	tmpplayer.get_node("lefthand").global_transform = lloc
	tmpplayer.get_node("head").global_transform = hloc
