extends Node3D


@export var offset: float = 20.0

@onready var parent := get_parent_node_3d()
@onready var prev_pos = parent.global_position

func _process(delta: float) -> void:
  var vel = parent.global_position - prev_pos
  global_position = parent.global_position + vel * offset
  prev_pos = parent.global_position

  
