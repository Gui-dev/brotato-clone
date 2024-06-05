extends CharacterBody2D
class_name EnemyBase


const _EXPLOSION: PackedScene = preload("res://effects/particles/explosion.tscn")
const  _TEXT_POPUP: PackedScene = preload("res://interface/text_popup.tscn")
var _loading_dash: bool = false
var _is_dashing: bool = false
var _previous_character_position: Vector2
@export_category("variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 192.0
@export var _dash_speed: float = 768
@export var _invincibility_cooldown: float = 0.5
@export var _damage: int = 3
@export var _health: int = 12

@export_category("objects")
@export var _hitbox_area: Area2D
@export var _dash_wait_time: Timer
@export var _dash_timer: Timer
@export var _invincibility_timer: Timer
@export var _animation_hit: AnimationPlayer


func _physics_process(_delta: float) -> void:
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
    direction = global_position.direction_to(_previous_character_position)
    velocity = direction * _dash_speed


func update_health(damage: int) -> void:
  _health -= damage
  
  if _health <= 0:
    get_tree().call_group("camera_player", "shake", 10.0, 0.35)
    _spawn_explosion_particles()
    queue_free()
    return
  
  get_tree().call_group("camera_player", "shake", 5.0, 0.25)
  _spawn_text_popup(damage)
  _animation_hit.play("hit")


func _spawn_text_popup(damage: int) -> void:
  var popup: TextPopup = _TEXT_POPUP.instantiate()
  popup.update_text(damage)
  popup.global_position = global_position
  get_tree().root.call_deferred("add_child", popup)
  

func _spawn_explosion_particles() -> void:
  var _particles: CPUParticles2D = _EXPLOSION.instantiate()
  _particles.global_position = global_position
  _particles.emitting = true
  get_tree().root.call_deferred("add_child", _particles)
  

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


func _on_hitbox_area_body_entered(body: Player) -> void:
  if body is Player:
    _hitbox_area.set_deferred("monitoring", false)
    _invincibility_timer.start(_invincibility_cooldown)
    body.update_health("damage", _damage)


func _on_invincibility_timer_timeout() -> void:
  _hitbox_area.set_deferred("monitoring", true)
