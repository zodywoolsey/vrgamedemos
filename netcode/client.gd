extends Node

var timer = 0
var playerupdatetimer = 0

const SERVER_IP = "192.168.1.10"
const PORT = 5000

var id

onready var vrscene = get_node("startup")

var nettestpanel
var nettestconnectbutton

onready var player = vrscene.get_node("player")

onready var label

var updatelocationflag = true
var networksignalflag = false

var connected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server",self, "_connected_to_server")
	get_tree().connect("server_disconnected",self, "_disconnected_from_server")
	if vrscene:
		nettestpanel = vrscene.get_node("nettest3dpanel")
		if nettestpanel:
			nettestconnectbutton = nettestpanel.get_node( "Viewport/gui/Button" )
			label = nettestpanel.get_node("Viewport/gui/Label")
			if nettestconnectbutton:
				nettestconnectbutton.connect("pressed",self,"nettestconnectbuttonpressed")


func _process(delta):
	
	if connected == true:
		rpc("_update_client_position",player.rloc,player.lloc,player.hloc,id)
		playerupdatetimer = 0

	playerupdatetimer += delta
	timer += delta

func _connected_to_server():
	rpc("_test","this is a test from the client",id)
	connected = true

func _disconnected_from_server():
	rpc("_test","this is a test from the client",id)
	connected = false

func loglbl(text):
	label.text = text

remote func _test(thing):
	loglbl(thing)
	
remote func _testid(thing,inid):
	loglbl(thing)
	# rpc_id(1,"_test","this is a response to message ( "+thing+" )", id)

func nettestconnectbuttonpressed():
	var client = NetworkedMultiplayerENet.new()
	client.create_client(SERVER_IP, PORT)
	get_tree().network_peer = client
	if networksignalflag == false:
		networksignalflag = true
	id = get_tree().get_network_unique_id()

