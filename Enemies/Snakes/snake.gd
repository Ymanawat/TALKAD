extends CharacterBody2D

var t = 4.0
var push_velocity = Vector2.ZERO

@export var ACCELERATION = 50
@export var MAX_SPEED = 50

@onready var sprite = $AnimatedSprite2D
@onready var Stats = $Stats
@onready var detectionZone = $BodyDetectionZone

enum {
	IDLE,
	CHASE,
}

var state = CHASE

func _physics_process(delta):	
	if push_velocity != Vector2.ZERO:
		# Apply linear interpolation to reduce velocity to zero
		velocity = velocity + push_velocity
		push_velocity = push_velocity.lerp(Vector2.ZERO, t * delta)
		state = CHASE
		
	match state:
		IDLE:
			velocity = velocity.lerp(Vector2.ZERO, t*delta)
			chase_player()
		CHASE:
			var player = detectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.lerp(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				push_velocity = Vector2.ZERO
				state = IDLE
				
	print(detectionZone.player)
	move_and_slide()
	
	
func chase_player():
	if detectionZone.body_detected():
		state = CHASE

func _on_hurt_box_area_entered(area):
	
	if Stats.health>1:
		# Create Hit Blood Effect
		var hurt_effect = load ("res://Effects/Hit Blood/HitBlood.tscn")
		var hurtEffect = hurt_effect.instantiate()
		get_parent().add_child(hurtEffect)
		hurtEffect.global_position = global_position
	
	# Set Health of the character (-1)
	Stats.health=-1
	
	# Give the character a velocity when the area is entered
	push_velocity = area.push_vector * 200
	
func _on_stats_dead():
	# Create Dead Blood Effect
	var dead_effect = load ("res://Effects/Dead Blood/DeadBlood.tscn")
	var deadEffect = dead_effect.instantiate()
	get_parent().add_child(deadEffect)
	deadEffect.global_position = global_position
	# emit signal when enemy is died
	emit_signal("enemy_died")
	# If health is 0 then character is dead so remove
	queue_free()
