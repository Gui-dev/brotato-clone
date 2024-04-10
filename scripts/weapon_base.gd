extends Node2D
class_name WeaponBase


var _is_attcking: bool = false
@export_category("Variables")
@export var _attack_damage: int
@export var _attack_cooldown: float

@export_category("objects")
@export var _attack_timer: Timer
@export var _animation_player: AnimationPlayer
@export var _detection_area: Area2D


func _on_detection_area_body_entered(body: EnemyBase) -> void:
  if _is_attcking: return
  
  if body is EnemyBase:
    _detection_area.set_deferred("monitoring", false)
    _animation_player.play("attack")
    _attack_timer.start(_attack_cooldown)
    _is_attcking = true


func _on_attack_timer_timeout() -> void:
  _is_attcking = false
  _detection_area.set_deferred("monitoring", true)


func _on_attack_area_body_entered(body: EnemyBase) -> void:
  if body is EnemyBase:
    body.update_health(_attack_damage)
