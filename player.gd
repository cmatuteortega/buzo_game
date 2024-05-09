extends CharacterBody2D

@export var movement_data : PlayerMovementDefault

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 300
var speed_bonus = 1
var on_attack = false
signal new_vida(vida)

# ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var vida = 100
@onready var starting_postition = global_position
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote = $coyote
@onready var buffer_salto = $buffer_salto
@onready var burbuja = $GPUParticles2D
@onready var collision_shape_2d = $attack_area/CollisionShape2D
@onready var buffer_ataque = $buffer_ataque

func _ready():
	Events.bubble_picked.connect(add_hp)

func _physics_process(delta):
	new_vida.emit(vida)
	print(on_attack)
	if vida <= 0:
		global_position = starting_postition
		vida = 100
	elif vida > 100:
		vida = 100
	else: 
		vida += -0.03 * speed_bonus
	
	apply_gravity(delta)
	attack_state()
	jump_state()
	
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_acceleration(input_axis,delta)
	apply_air_acceleration(input_axis,delta)
	apply_friction(input_axis,delta)
	apply_air_resistance(input_axis,delta)
	update_animations(input_axis)
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote.start()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * movement_data.gravity_scale * movement_data.gravity_scale

func jump_state():
	if on_attack == false:
		if is_on_floor() or coyote.time_left > 0.0:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = movement_data.jump_velocity
				vida += -10
		if not is_on_floor():
			if Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jump_velocity/2:
				velocity.y = movement_data.jump_velocity/3
				vida += -5
			if Input.is_action_just_pressed("ui_accept") and buffer_salto.time_left <= 0.0 and coyote.time_left <= 0.0:
				velocity.y = movement_data.jump_velocity * 0.6
				buffer_salto.start()
				vida += -15

func attack_state():
	on_attack = false
	collision_shape_2d.disabled = true
	if not buffer_ataque.is_stopped():
		on_attack = true
		collision_shape_2d.disabled = false
	
	# atacar en el suelo
	if Input.is_action_just_pressed("attack") and is_on_floor() and buffer_ataque.time_left == 0.0:
		collision_shape_2d.disabled = false
		on_attack = true
		buffer_ataque.start()
	# atacar en el aire hacia abajo
	if Input.is_action_pressed("attack") and Input.is_action_pressed("ui_down") and not is_on_floor() and buffer_ataque.time_left <= 0.0:
		on_attack = true
	# atacar hacia arriba
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("ui_up") and buffer_ataque.time_left <= 0.0:
		on_attack = true
		buffer_ataque.start()


func apply_friction(input_axis,delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction*delta)

func apply_air_resistance(input_axis,delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance*delta)

func apply_acceleration(input_axis,delta):
	if not is_on_floor(): return
	if Input.is_action_pressed("ui_dash"):
		speed_bonus = 1.5
	else:
		speed_bonus = 1
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed * speed_bonus,movement_data.acceleration * delta)

func apply_air_acceleration(input_axis,delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed * speed_bonus,movement_data.air_acceleration * delta)

func update_animations(input_axis):
	if on_attack == true or buffer_ataque.time_left > 0.0:
		if Input.is_action_pressed("ui_down") and not is_on_floor():
			#animated_sprite_2d.offset.()
			animated_sprite_2d.play("down_air")
			animated_sprite_2d.offset.y = 4
			return
		if Input.is_action_pressed("ui_up"):
			#animated_sprite_2d.offset.()
			animated_sprite_2d.play("up_air")
			return
		animated_sprite_2d.play("attack")
		if animated_sprite_2d.flip_h == false:
			animated_sprite_2d.offset.x = 8
		else:
			animated_sprite_2d.offset.x = -8
	
	
	if on_attack == false:
		animated_sprite_2d.offset.x = 0
		animated_sprite_2d.offset.y = 0
		if is_on_floor():
			if input_axis != 0:
				animated_sprite_2d.flip_h = (input_axis < 0)
				animated_sprite_2d.play("walk")
			elif Input.is_action_pressed("ui_up"):
				animated_sprite_2d.play("lookup")
			elif Input.is_action_pressed("ui_down"):
				animated_sprite_2d.play("duck")
			else :
				animated_sprite_2d.play("idle")
		
		if not is_on_floor() and velocity.y < 0:
			if input_axis != 0:
				animated_sprite_2d.flip_h = (input_axis < 0)
			animated_sprite_2d.play("jump")
			burbuja.emitting = true
		
		if not is_on_floor() and velocity.y > 0:
			if input_axis != 0:
				animated_sprite_2d.flip_h = (input_axis < 0)
			animated_sprite_2d.play("fall")



func _on_hazard_detector_area_entered(_area):
	velocity.y = movement_data.jump_velocity * 0.9
	vida += -15
	burbuja.emitting = true
	#global_position = starting_postition # Replace with function body.

func add_hp():
	vida += 50
