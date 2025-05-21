extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $Area2D/HitBox
@onready var area2DCollision = $AreaHero/CollisionShape2D

var is_attacking = false
@export var speed: float = 100.0

@onready var hp_bar: ProgressBar = $ProgressBar
@export var hp = 5

var is_dead = false

@onready var kill_label: Label = $Label 
var kill_count = 0

func _ready():
	hp_bar.max_value = 5
	hp_bar.value = hp

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	hp_bar.value = hp
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

func add_kill():
	kill_count += 1
	kill_label.text = "Kill: %d" % kill_count

func attack():
	is_attacking = true
	animation_player.play("Attack")
	hitbox.disabled = false
	await animation_player.animation_finished
	hitbox.disabled = true
	is_attacking = false


func _on_area_hero_area_entered(area: Area2D) -> void:
	if is_dead:
		return
	
	if area.is_in_group("Enemy"):
		hp -= 1
		if hp <= 0:
			die()
	pass # Replace with function body.

func die():
	is_dead = true
	animation_player.play("Death")
	velocity = Vector2.ZERO
	set_physics_process(false)  
	# หยุดการประมวลผลการเคลื่อนไหว
	hitbox.disabled = true
	#area2DCollision.disabled = true
