extends Area2D
class_name Projectile


var direction: Vector2
var _attack_damage: int
@export_category("Properties")
@export var _move_speed: float = 512.0


func _ready() -> void:
  rotation = direction.angle()


func _physics_process(delta) -> void:
  translate(
    direction * delta * _move_speed
  )


func _on_attack_area_body_entered(body: EnemyBase) -> void:
  if body is EnemyBase:
    body.update_health(_attack_damage)
    queue_free()
