extends Node

@export var max_health = 1
@onready var health = max_health : set = set_health, get = get_health

signal dead

func set_health(change_in_health: int) -> void:
	health += change_in_health
	if health <= 0:
		emit_signal("dead")
		
func get_health() -> int:
	return health
