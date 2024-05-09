extends Node

@onready var label = $Control/Label
@onready var sprite_2d = $Control3/Sprite2D
@onready var sprite_2d_2 = $Control3/Sprite2D2
@onready var sprite_2d_3 = $Control3/Sprite2D3
@onready var sprite_2d_4 = $Control3/Sprite2D4
@onready var sprite_2d_5 = $Control3/Sprite2D5

@onready var animated_sprite_2d_5 = $Control3/AnimatedSprite2D5
@onready var animated_sprite_2d_4 = $Control3/AnimatedSprite2D4
@onready var animated_sprite_2d_3 = $Control3/AnimatedSprite2D3
@onready var animated_sprite_2d_2 = $Control3/AnimatedSprite2D2
@onready var animated_sprite_2d_1 = $Control3/AnimatedSprite2D1

@onready var bubble_5_popped = false
@onready var bubble_4_popped = false
@onready var bubble_3_popped = false
@onready var bubble_2_popped = false
@onready var bubble_1_popped = false

func _on_player_new_vida(vida):
	label.text = "O2: " + str(round(vida)) + "%"
	if vida <= 80:
		sprite_2d_5.visible = false
		if bubble_5_popped == false:
			animated_sprite_2d_5.visible = true
			animated_sprite_2d_5.play()
			if animated_sprite_2d_5.frame == 2:
				bubble_5_popped = true
				animated_sprite_2d_5.visible = false
	if vida <= 60:
		sprite_2d_4.visible = false
		if bubble_4_popped == false:
			animated_sprite_2d_4.visible = true
			animated_sprite_2d_4.play()
			if animated_sprite_2d_4.frame == 2:
				bubble_4_popped = true
				animated_sprite_2d_4.visible = false
	if vida <= 40:
		sprite_2d_3.visible = false
		if bubble_3_popped == false:
			animated_sprite_2d_3.visible = true
			animated_sprite_2d_3.play()
			if animated_sprite_2d_3.frame == 2:
				bubble_3_popped = true
				animated_sprite_2d_3.visible = false
	if vida <= 20:
		sprite_2d_2.visible = false
		if bubble_2_popped == false:
			animated_sprite_2d_2.visible = true
			animated_sprite_2d_2.play()
			if animated_sprite_2d_2.frame == 2:
				bubble_2_popped = true
				animated_sprite_2d_2.visible = false
	#if vida <= 0:
		#sprite_2d.visible = false
		#if bubble_1_popped == false:
			#animated_sprite_2d_1.visible = true
			#animated_sprite_2d_1.play()
			#if animated_sprite_2d_1.frame == 2:
				#bubble_1_popped = true
				#animated_sprite_2d_1.visible = false
	if vida > 80:
		sprite_2d_5.visible = true
		bubble_5_popped = false
	if vida > 60:
		sprite_2d_4.visible = true
		bubble_4_popped = false
	if vida > 40:
		sprite_2d_3.visible = true
		bubble_3_popped = false
	if vida > 20:
		sprite_2d_2.visible = true
		bubble_2_popped = false
	#if vida > 0:
		#sprite_2d.visible = true
		#bubble_1_popped = false
