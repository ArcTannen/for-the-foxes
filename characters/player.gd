extends CharacterBody2D


@onready var sprite = get_node("AnimatedSprite2D")
@onready var anim = get_node("AnimationPlayer")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:  # falling
			anim.play("Fall")

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:  # not jumping or falling
			anim.play("Run")
			
		if direction == -1:
			sprite.flip_h = true
		elif direction == 1:
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:  # not jumping or falling
			anim.play("Idle")

	move_and_slide()
	
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
