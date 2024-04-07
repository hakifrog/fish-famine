extends CharacterBody2D


const SPEED = 300.0

var food = null
@onready var AnimPlay = $PumpAnimation
func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if food != null:
		if Input.is_action_just_pressed("ui_left"):
			food.apply_central_impulse(Vector2(-3,0))
		if Input.is_action_just_pressed("ui_right"):
			food.apply_central_impulse(Vector2(3,0))


	move_and_slide()


func _on_area_2d_body_entered(body):
	food = body
