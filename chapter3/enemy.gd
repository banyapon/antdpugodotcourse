extends CharacterBody2D
class_name Enemy

@export var speed: float = 50.0
@export var player_path: NodePath
@onready var player = get_node_or_null(player_path)

@export var knockback_distance: float = 50.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var blink_timer: Timer = $BlinkTimer
@onready var death_timer: Timer = $DeathTimer

var is_dead = false
var hit_count = 0
var blink_count = 0
var knockback_vector = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not player or is_dead: 
		return

	var distance = global_position.distance_to(player.global_position)
	if distance < 1.0:
		velocity = Vector2.ZERO
		animation_player.play("Attack")
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		if direction.x != 0:
			sprite.flip_h = direction.x < 0

		animation_player.play("Walk")
		

func show_hit_effect():
	sprite.modulate = Color(1, 0.2, 0.2)  # สีแดง
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color(1, 1, 1)      # คืนสีเดิม

func die():
	is_dead = true
	velocity = Vector2.ZERO
	animation_player.play("Death")
	death_timer.start(0.8)

func _on_DeathTimer_timeout():
	blink_timer.start(0.1)  # เริ่มกระพริบ

func _on_BlinkTimer_timeout():
	sprite.visible = not sprite.visible
	blink_count += 1

	if blink_count >= 5:  # กระพริบครบ 0.5 วินาที (5 ครั้ง × 0.1s)
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_dead:
		return

	if area == get_tree().get_first_node_in_group("HitBox"):
		hit_count += 1
		show_hit_effect()

		# กระเด็นถอยหลังจากตำแหน่ง player
		var push_dir = (global_position - player.global_position).normalized()
		global_position += push_dir * knockback_distance

		if hit_count >= 2:
			die()
