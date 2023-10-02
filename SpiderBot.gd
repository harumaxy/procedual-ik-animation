extends Node3D


@export var move_speed: float = 5.0
@export var turn_speed: float = 1.0
@export var ground_offset: float = 0.5

@onready var fl_leg = $Armature/FrontLeftIKTarget
@onready var fr_leg = $Armature/FrontRightIKTarget
@onready var bl_leg = $Armature/BackLeftIKTarget
@onready var br_leg = $Armature/BackRightIKTarget


func _process(delta: float) -> void:
  # Plane: made by 3 vectors around clock. That can provide normal.
  var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
  var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
  
  # get appropriate body UP vec
  var avg_normal = (plane1.normal + plane2.normal / 2).normalized()
  var target_basis = basis_from_normal(avg_normal)
  self.transform.basis = lerp(self.transform.basis, target_basis, move_speed * delta).orthonormalized()
  
  var avg = [fl_leg, fr_leg, bl_leg, br_leg].reduce(func(acc, v):
    return acc + v.position
    , Vector3()) / 4
  var target_pos = avg + transform.basis.y * ground_offset
  var distance = transform.basis.y.dot(target_pos - position)
  position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
  
  move(delta)
  
  
func move(delta: float):
  var dir := Input.get_axis('ui_down', 'ui_up')
  self.translate(Vector3.FORWARD * dir * move_speed * delta)
  var a_dir = Input.get_axis('ui_right', 'ui_left')
  rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)

func basis_from_normal(normal: Vector3) -> Basis:
  var res = Basis()
  res.x = normal.cross((self.transform.basis.z))
  res.y = normal
  res.z = self.transform.basis.x.cross(normal)
  res = res.orthonormalized()
  res.x *= scale.x
  res.y *= scale.y
  res.z *= scale.z
  return res
  
