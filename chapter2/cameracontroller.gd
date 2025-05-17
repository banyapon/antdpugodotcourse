extends Camera2D

@export var target_node_path: NodePath = NodePath("")

var target: Node2D

func _ready() -> void:
	if target_node_path != NodePath(""):
		target = get_node_or_null(target_node_path)

func _process(delta: float) -> void:
	if target:
		global_position = target.global_position
