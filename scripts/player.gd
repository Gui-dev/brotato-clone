extends CharacterBody2D
class_name Player


var _max_health: int
@export_category("variables")
@export var _move_speed: float = 256.0
@export var _health: int = 20
@export_category("objects")
@export var _dust: CPUParticles2D = null


func _ready() -> void:
  _max_health = _health
  GlobalBase.player = self 


func _physics_process(_delta: float) -> void:
  _move()
  
  
func _move() -> void:
  var _direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
  
  velocity = _direction * _move_speed
  move_and_slide()
  
  if _direction:
    _dust.emitting = true
    return
    
  _dust.emitting = false


func update_health(type: String, value: int) -> void:
  match type:
    "damage":
      _health -= value
      if _health <= 0:
        print("Morreu...")
        #queue_free()
    "heal":
      _health += value
      if _health > _max_health:
        _health = _max_health


func _on_wave_timer_timeout():
  pass # Replace with function body.
