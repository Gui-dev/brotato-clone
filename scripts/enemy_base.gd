extends CharacterBody2D
class_name EnemyBase


var _loading_dash: bool = false
var _is_dashing: bool = false
var _previous_character_position: Vector2
@export_category("variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 192.0
@export var _dash_speed: float = 768
@export var _dash_wait_time: Timer
@export var _dash_timer: Timer


func _physics_process(delta: float) -> void:
  if _loading_dash:
    return
  
  if not GlobalBase.player:
    print("Personagem não encontrado")
    return
    
  var _direction: Vector2 = global_position.direction_to(GlobalBase.player.global_position)
  var _distance: float = global_position.distance_to(GlobalBase.player.global_position)
  
  if _distance <= 16.0:
    #aplicar logica de ataque aqui
    return
  
  match _enemy_type:
    "chase":
      _chase(_direction)
    "chase_and_dash":
      _chase_and_dash(_direction)
  move_and_slide()


func _chase(direction: Vector2) -> void:
  velocity = direction * _move_speed
  
  
func _chase_and_dash(direction: Vector2) -> void:
  if not _is_dashing:
    velocity = direction * _move_speed
  
  if _is_dashing:
    velocity = direction * _dash_speed


func _on_range_area_body_entered(body: Player) -> void:
  if _enemy_type != "chase_and_dash":
    return
  
  if _is_dashing:
    return
    
  if body is Player:
    _previous_character_position = GlobalBase.player.global_position
    _dash_wait_time.start()
    _loading_dash = true


func _on_dash_wait_time_timeout():
  _loading_dash = false
  _is_dashing = true
  _dash_timer.start()


func _on_dash_timer_timeout():
  _is_dashing = false
