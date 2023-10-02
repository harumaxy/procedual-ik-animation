extends Marker3D

@export var step_target: Node3D
@export var step_distance: float = 3
@export var adjacent_target: Node3D
@export var opposite_target: Node3D

var is_stepping := false

func _process(delta: float) -> void:
  if !is_stepping && !adjacent_target.is_stepping && \
     abs(global_position.distance_to(step_target.global_position)) > step_distance:
    step()
    opposite_target.step()
  
func step():
  is_stepping = true
  var half_way = (global_position + step_target.global_position) / 2
  var tw = get_tree().create_tween()
  tw.tween_property(self, "global_position", half_way + owner.basis.y * 2, 0.1)
  tw.tween_property(self, "global_position", step_target.global_position, 0.1)
  tw.tween_callback(func(): is_stepping = false)
