extends Node2D
const width = 1000
const height = 20
var spawnArea = Rect2()
const food = preload("res://Scenes/food_particle.tscn")
var delta = 2
var offset = 0.25

func _ready():
	randomize()
	spawnArea = Rect2(0,0, width,height)
	nextSpawn()
	
func spawnfood():
	var position = Vector2(randi()%width, randi()%height)
	var foodp = food.instantiate()
	foodp.position = position
	$"..".add_child(foodp)
	return position
	
func nextSpawn():
	var nextTime= delta +(randf()-0.5)*2*offset
	$Timer.wait_time = nextTime
	$Timer.start()


func _on_timer_timeout():
	spawnfood()
	nextSpawn()
