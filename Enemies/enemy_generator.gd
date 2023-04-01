extends Area2D

@onready var target_node = get_node("../CharacterBody2D")
@onready var snake = preload("res://Enemies/Snakes/snake.tscn")
@onready var generator = get_node(".")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(target_node.global_position)
	generate_enemies(10)


func generate_enemies(num_enemies: int):
	
	for i in range(num_enemies):
		# Generate a random position within the area of the circle
		var pos = Vector2(randi_range(-400, 400), randi_range(-400, 400))

		# Create the enemy node and add it to the scene
		var enemy = snake.instantiate()
		get_parent().add_child(enemy)

		# Set the enemy's position relative to the player
		enemy.position = position + pos

func on_enemy_died():
	generate_enemies(1)
