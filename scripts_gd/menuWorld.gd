extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var floorTileScene
var floorTiles = []
var litTileScene

var tmpTile
var tileMoveFlag = true

var i = 0
var a = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	floorTileScene = load("res://scenes/floorTile.tscn")

	# for i in range(2):
	# 	tmpTile = floorTileScene.instance()
	# 	add_child(tmpTile)
	# 	tmpTile.translate(Vector3(-.5+i,0,0))
	# 	floorTiles.append(tmpTile)

	for i in range(20):
		for a in range(20):
			tmpTile = floorTileScene.instance()
			#tmpTile.translate(Vector3(((a)-4), -200+i, -i+5))
			tmpTile.global_transform.origin = Vector3(((a)-10), -500+((i+a)*10), -i+10)
			add_child(tmpTile)
			floorTiles.append(tmpTile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tileMoveFlag == true:
		checkAndMoveTiles()

func checkAndMoveTiles():
	tileMoveFlag = false
	for tile in floorTiles:
		var tmpOrig = tile.global_transform.origin
		if tile.global_transform.origin.y != 0:
			# tile.translate(Vector3(0,1+(tile.global_transform.origin.y/4),0))
			tile.global_transform.origin = Vector3(tmpOrig.x,tmpOrig.y/1.01,tmpOrig.z)
			if tile.global_transform.origin.y > -1 && tile.global_transform.origin.y != 0:
				tile.global_transform.origin = Vector3(tmpOrig.x,tmpOrig.y+.01,tmpOrig.z)
				# tile.global_transform.origin = Vector3( tile.global_transform.origin.x, 0, tile.global_transform.origin.z )
			if tile.global_transform.origin.y > 0:
				tile.global_transform.origin = Vector3( tile.global_transform.origin.x, 0, tile.global_transform.origin.z )
			if tile.global_transform.origin.y != 0:
				tileMoveFlag = true
