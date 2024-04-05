extends CharacterBody2D


const time= 0.2
var timer= 0

func _physics_process(delta):
	timer += delta
	if timer >= time:
		queue_free()
