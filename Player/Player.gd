extends CharacterBody2D

const SPEED = 100.0
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitBox = $Marker2D/HitBox

enum{
	MOVE,
	HIT
}

var playerState = MOVE

func _ready():
	animationTree.active = true
	swordHitBox.push_vector = Vector2.ZERO

func _physics_process(delta):
	match playerState:
		MOVE:
			move_()
		HIT:
			hit()

	move_and_slide()

func move_():
	var direction = get_input_direction()
	if direction:
		swordHitBox.push_vector = direction
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Run/blend_position", direction)
		animationTree.set("parameters/Dig/blend_position", direction)
		animationTree.set("parameters/Hit/blend_position", direction)
		animationState.travel("Run")
		velocity = direction * SPEED
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("Hit"):
		velocity = Vector2.ZERO
		playerState = HIT

func get_input_direction():
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	return direction.normalized()

func hit():
	animationState.travel("Hit")
	
func _on_action_animation_finished():
	playerState = MOVE
