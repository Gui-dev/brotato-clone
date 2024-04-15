extends CanvasLayer
class_name Interface


@export_category("objects")
@export var _wave_and_time: Label


func update_wave_and_time_label(wave: int, time_remaining: int) -> void:
  _wave_and_time.text = (
    "Wave " + str(wave) + "\n" +
    "Time - " + _time_in_seconds(time_remaining)
  )


func _time_in_seconds(time: int) -> String:
  var seconds: float = time % 60
  @warning_ignore("integer_division")
  var minutes: float = (time / 60) % 60
  return "%02d:%02d" % [minutes, seconds]
