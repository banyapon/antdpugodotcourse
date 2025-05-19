extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $Area2D/HitBox

var is_attacking = false
@export var speed: float = 100.0

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# ถ้าโจมตีอยู่ ไม่ให้เคลื่อนที่หรือเปลี่ยนแอนิเมชัน
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# ตรวจจับการเคลื่อนไหว
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()

	# flip sprite
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0

	# เล่นแอนิเมชันเดิน/นิ่ง
	if direction == Vector2.ZERO:
		animation_player.play("Idle")
	else:
		animation_player.play("Walk")

	# ตรวจจับการกดปุ่มโจมตี
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

func attack():
	is_attacking = true
	animation_player.play("Attack")
	hitbox.disabled = false

	await animation_player.animation_finished

	hitbox.disabled = true
	is_attacking = false
