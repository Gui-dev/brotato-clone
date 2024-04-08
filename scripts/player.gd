extends CharacterBody2D
class_name Player


@export_category("variables")
@export var _move_speed: float = 256.0


func _ready() -> void:
  GlobalBase.player = self 


func _physics_process(delta: float) -> void:
  _move()
  
  
func _move() -> void:
  var _direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
  velocity = _direction * _move_speed
  move_and_slide()
