extends CharacterBody2D


@export var MovementSpeed = 300.0
@export var VerticalImpulseForce = 1.0
@export var HorizontalImpulseForce = 1.0

@onready var AnimPlay = $PumpAnimation
@onready var CharBase = $CollisionShape2D
@onready var ForceArea = $Area2D
@onready var robotsound = $"../Sounds/robot_long"

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"):
		robotsound.play()
	elif Input.is_action_just_released("left") || Input.is_action_just_released("right"):
		robotsound.stop()
		return
		
		
	if direction:
		velocity.x = direction * MovementSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, MovementSpeed)
	
	for body in ForceArea.get_overlapping_bodies():
		var pushImpulse = Vector2(direction * HorizontalImpulseForce, -VerticalImpulseForce);
		if (body.linear_velocity.y > 0):
			pushImpulse.y *= 2
		
		if Input.is_action_pressed("shoot"):
			body.apply_central_impulse(pushImpulse)
		
	move_and_slide()
