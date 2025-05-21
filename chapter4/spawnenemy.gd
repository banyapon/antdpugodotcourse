extends Node2D

@export var isSpawn := false
var enemy_prefab  = preload("res://enemy.tscn")

func _ready():
	set_process(true)
	pass

func _process(delta):
	if !isSpawn:
		isSpawn = true
		var timer_count = randf_range(1.0,5.0)
		await get_tree().create_timer(timer_count).timeout
		spawning_enemy()
		isSpawn = false
	pass

func spawning_enemy():
	var enemy_instance = enemy_prefab.instantiate()
	var player_node = get_node("../Player")
	if player_node:
		enemy_instance.player_path = player_node.get_path()
	enemy_instance.global_position = get_random_position()
	get_parent().add_child(enemy_instance)

func get_random_position():
	var random_x = randf_range(-20, 100)
	var random_y = randf_range(-12, 80)
	return Vector2(random_x, random_y)
