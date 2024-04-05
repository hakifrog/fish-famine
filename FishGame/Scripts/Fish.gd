extends CharacterBody2D

var speed: float = 90
var chasing: bool = false
var food = null
var wander_range: float = 500
var target_position: Vector2 = Vector2()
@onready var flipper = $Flipper
@onready var AnimPlay = $FishAnimation


var pause_timer: float = randf_range(0.5, 2.5)
var pause_time: float = 0.0
var pauseState: bool = false

func select_new_target():
	var random_position = position + Vector2(randf_range(randf_range(-wander_range, -100), randf_range(100, wander_range)), randf_range(-wander_range, wander_range))
	target_position = random_position.clamp(Vector2(50, 50), Vector2(1100, 425))

func _ready():
	select_new_target()

func move_to_target():
	velocity = (target_position - position).normalized() * speed

func _physics_process(delta):
	if food != null:
		velocity = Vector2.ZERO
		velocity = position.direction_to(food.position) * speed
	elif food == null:
		if pauseState:
			pause_time += delta
			if pause_time >= pause_timer:
				pause_time = 0.0
				pauseState = false
				select_new_target()
				move_to_target()
		else:
			if position.distance_to(target_position) < 10:
				pauseState = true
				AnimPlay.play("idle")
				velocity = Vector2.ZERO
				return
			move_to_target()

	if velocity.x < 0:
		flipper.scale.x = 1
	elif velocity.x > 0:
		flipper.scale.x = -1

	move_and_slide()

func _on_food_detector_body_entered(body):
	food = body
	chasing = true

func _on_food_detector_body_exited(body):
	food = null
	chasing = false
