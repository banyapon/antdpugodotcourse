extends CharacterBody2D
# ความเร็วในการเคลื่อนที่ของตัวละคร
@export var speed: float = 200.0
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	# ตรวจจับปุ่มกดลูกศร
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# ทำให้การเคลื่อนที่เป็นแนวทแยงได้ราบเรียบ
	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# ตั้งค่าความเร็วให้กับตัวละคร
	velocity = direction * speed

	# สั่งให้ตัวละครเคลื่อนที่ตามฟิสิกส์
	move_and_slide()
	
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x < 0
