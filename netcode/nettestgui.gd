extends Control


onready var zero = 			get_node("0")
onready var one = 			get_node("1")
onready var two = 			get_node("2")
onready var three = 		get_node("3")
onready var four = 			get_node("4")
onready var five = 			get_node("5")
onready var six = 			get_node("6")
onready var seven = 		get_node("7")
onready var eight = 		get_node("8")
onready var nine = 			get_node("9")
onready var dot = 			get_node("dot")
onready var backspace = 	get_node("backspace")

onready var inputip = 		get_node("inip")


# Called when the node enters the scene tree for the first time.
func _ready():
	zero.connect("pressed",self,"zeropressed")
	one.connect("pressed",self,"onepressed")
	two.connect("pressed",self,"twopressed")
	three.connect("pressed",self,"threepressed")
	four.connect("pressed",self,"fourpressed")
	five.connect("pressed",self,"fivepressed")
	six.connect("pressed",self,"sixpressed")
	seven.connect("pressed",self,"sevenpressed")
	eight.connect("pressed",self,"eightpressed")
	nine.connect("pressed",self,"ninepressed")
	dot.connect("pressed",self,"dotpressed")
	backspace.connect("pressed",self,"backspacepressed")

func zeropressed():
	inputip.text += "0"
func onepressed():
	inputip.text += "1"
func twopressed():
	inputip.text += "2"
func threepressed():
	inputip.text += "3"
func fourpressed():
	inputip.text += "4"
func fivepressed():
	inputip.text += "5"
func sixpressed():
	inputip.text += "6"
func sevenpressed():
	inputip.text += "7"
func eightpressed():
	inputip.text += "8"
func ninepressed():
	inputip.text += "9"
func dotpressed():
	inputip.text += "."
func backspacepressed():
	var tmp = ""
	for i in range(inputip.text.length()-1):
		tmp += inputip.text[i]
	inputip.text = tmp


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
