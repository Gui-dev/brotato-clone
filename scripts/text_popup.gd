extends Label
class_name TextPopup


var _factor: float = 32.0


func _physics_process(delta: float) -> void:
  position.y -= delta * _factor


func update_text(value: int) -> void:
  text = "-" + str(value)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
  queue_free()
