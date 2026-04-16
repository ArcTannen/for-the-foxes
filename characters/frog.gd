extends CharacterBody2D


@onready var sprite = get_node("AnimatedSprite2D")
@onready var player = get_node("../../Player/Player")

const SPEED = 50.0
#const JUMP_VELOCITY = -250.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chasing = false
var dead = false


func _ready():
	sprite.play("Idle")


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:  # falling
			pass #sprite.play("Jump")
	
	# Movement
	if not dead:
		if chasing:
			var player_direction = (player.position - position).normalized()
			
			sprite.play("Jump")
			velocity.x = player_direction.x * SPEED
			
			if player_direction.x > 0:
				sprite.flip_h = true
			elif player_direction.x < 0:
				sprite.flip_h = false
		else:
			sprite.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		sprite.play("Death")
		velocity = Vector2.ZERO  # so death animation doesn't keep moving
		await sprite.animation_finished
		queue_free()
	
	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chasing = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chasing = false


func _on_frog_death_body_entered(body):
	if body.name == "Player":
		dead = true
		Game.playerGP += 5
		Utils.saveGame()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 2
