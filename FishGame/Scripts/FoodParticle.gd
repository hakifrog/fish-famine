extends RigidBody2D

@onready var fishAte = null
var countDown = 15
var clock = 0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	clock += delta
	if clock >= countDown:
		queue_free()


func _on_fish_mouth_detector_body_entered(body):
	if body != null and body.name == "Flipper":
		queue_free()
