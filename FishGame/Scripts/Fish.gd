extends CharacterBody2D

enum HungerState {
	STARVED,
	HUNGRY,
	HEALTHY,
	FULL,
	OBESE,
	OLD
}

@onready var fishMoved = $Sounds/fishMovement
@onready var foodcracked = $Sounds/FoodCrack
@onready var FishTankBG = $"../Sounds/fishtankbg"
var speed: float = 120
var chasing: bool = false
var food = null
var foodEaten = null
var wander_range: float = 500
var target_position: Vector2 = Vector2()
@onready var flipper = $Flipper
@onready var AnimPlay = $FishAnimation
var animtimer = 0

@export var hunger_level: float = 50
var hunger_state: HungerState = HungerState.HEALTHY
var hunger_depletion_rate: float = 10

var pause_timer: float = randf_range(0.5, 2.5)
var pause_time: float = 0.0
var pause_state: bool = false
var counter = 0

var OldAge = false

var threshold_counter: int = 10
var timer_duration: float = 75
var timer_running: bool = false
var timer_time: float = 0

var OverAlltimer_duration: float = 300
var OverAlltimer_running: bool = true
var OverAlltimer_time: float = 0

var deathTimer = 0

func select_new_target():
	var random_position = Vector2(randi_range(150, 1100), randi_range(150, 425))
	target_position = random_position
	fishMoved.play()
	

func move_to_target():
	velocity = (target_position - position).normalized() * speed




func _ready():
	FishTankBG.play()
	select_new_target()


func update_hunger_state():
	var old_state = hunger_state
	
	if hunger_level <= 20 && OldAge == false:
		hunger_state = HungerState.STARVED
	elif hunger_level <= 40 && hunger_level > 20  && OldAge == false:
		hunger_state = HungerState.HUNGRY
	elif hunger_level < 80 && hunger_level >= 60 && OldAge == false:
		hunger_state = HungerState.FULL
	elif hunger_state > 40 && hunger_level < 60  && OldAge == false:
		hunger_state = HungerState.HEALTHY
	elif hunger_level >= 80 && OldAge == false:
		hunger_state = HungerState.OBESE
	elif OldAge == true:
		hunger_state = HungerState.OLD

	if old_state != hunger_state:
		counter += 1 

func _physics_process(delta):
	hunger_level -= delta*1.7
	print(hunger_level)
	if counter >= threshold_counter and not timer_running:
		# Start the timer
		#Apply all the old-age sprite animations
		timer_running = true
		timer_time = 0
	if timer_running:
		timer_time += delta
		if timer_time >= timer_duration:
			OldAge = true
			# Reset the timer state
			timer_running = false
			timer_time = 0
			

	if OverAlltimer_running:
		OverAlltimer_time += delta
		if OverAlltimer_time >= OverAlltimer_duration:
			OldAge = true
			# Reset the timer state
			timer_running = true
			timer_time = 0
	
	if OldAge:
		deathTimer += delta
		if deathTimer >= 300: # 300 secs = 5 minutes
			#Trigger Old Age death ending by transitioning to the Old Age death scene
			print("Ending")
	
	
	if hunger_level > 100:
		get_tree().change_scene_to_file("res://Scenes/b_game_over.tscn")
	if hunger_level < 0:
		get_tree().change_scene_to_file("res://Scenes/StarvationEnding.tscn")
	
	update_hunger_state()
	var chase_speed_multiplier = 1.0

	match hunger_state:
		HungerState.STARVED:
			chase_speed_multiplier = 2.25
		HungerState.HUNGRY:
			chase_speed_multiplier = 1.5
		HungerState.HEALTHY:
			chase_speed_multiplier = 1.0
		HungerState.FULL:
			chase_speed_multiplier = 0.4
		HungerState.OBESE:
			chase_speed_multiplier = 0.3
		HungerState.OLD:
			chase_speed_multiplier = 0.3
	if food != null:
		velocity = Vector2.ZERO
		velocity = position.direction_to(food.position) * speed * chase_speed_multiplier
	elif food == null:
		if pause_state:
			pause_time += delta
			if pause_time >= pause_timer:
				pause_time = 0.0
				pause_state = false
				select_new_target()
				move_to_target()
		else:
			if position.distance_to(target_position) < 10:
				pause_state = true
				velocity = Vector2.ZERO
				return
			move_to_target()
			
	if pause_state == true && hunger_state == HungerState.STARVED:
		AnimPlay.play("starvingidle")
	elif pause_state == false && hunger_state == HungerState.STARVED:
		AnimPlay.play("starving_swim")
	elif pause_state == true && hunger_state == HungerState.HUNGRY:
		AnimPlay.play("hungryidle")
	elif pause_state == false && hunger_state == HungerState.HUNGRY:
		AnimPlay.play("hungryswim")
	elif pause_state == true && hunger_state == HungerState.HEALTHY:
		AnimPlay.play("healthyidle")
	elif pause_state == false && hunger_state == HungerState.HEALTHY:
		AnimPlay.play("healthyswim")
	elif pause_state == true && hunger_state == HungerState.FULL:
		AnimPlay.play("fullidle")
	elif pause_state == false && hunger_state == HungerState.FULL:
		AnimPlay.play("fullswim")
	elif pause_state == true && hunger_state == HungerState.OBESE:
		AnimPlay.play("fatidle")
	elif pause_state == false && hunger_state == HungerState.OBESE:
		AnimPlay.play("fatswim")

	adjust_speed_based_on_hunger()

	if velocity.x < 0:
		flipper.scale.x = 1
	elif velocity.x > 0:
		flipper.scale.x = -1

	move_and_slide()

func adjust_speed_based_on_hunger():
	match hunger_state:
		HungerState.STARVED:
			speed = 50
		HungerState.HUNGRY:
			speed = 65
		HungerState.HEALTHY:
			speed = 105
		HungerState.FULL:
			speed = 65
		HungerState.OBESE:
			speed = 50
		HungerState.OLD:
			speed = 40

func _on_food_detector_body_entered(body):
	food = body
	chasing = true

func _on_food_detector_body_exited(body):
	food = null
	chasing = false


func _on_area_2d_body_entered(body2):
	hunger_level += 3.85
	return
