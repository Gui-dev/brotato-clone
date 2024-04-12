extends Camera2D
class_name CameraPlayer


var _current_strength: float
var _current_length: float


func shake(strength: float, length: float) -> void:
  if _current_length != 0:
    return
  
  _current_strength = strength
  _current_length = length
  
  while _current_length > 0:
    offset = Vector2(
      randf_range(-_current_strength, + _current_strength),
      randf_range(-_current_strength, + _current_strength)
    )
    _current_strength -= get_process_delta_time()
    await get_tree().physics_frame
    
  offset = Vector2.ZERO
  _current_strength = 0
  _current_length = 0
