extends RigidBody2D

@onready var fishAte = null
var countDown = 15
var clock = 0

signal fish_ate_food

func _ready():
	pass
	



<<<<<<< HEAD
func _process(delta):
	
	clock += delta
	if clock >= countDown:
		queue_free()
=======
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	#clock += delta
	#if clock >= countDown:
		#queue_free()
>>>>>>> 7d105693fc4086406a1257920ab85d9b817710fb


func _on_fish_mouth_detector_body_entered(body):
	if body != null and body.name == "Flipper":
		emit_signal("fish_ate_food")
		queue_free()
