extends Node2D
class_name WaveManager


const _GREEN_ENEMY: PackedScene = preload("res://enemies/enemy_green.tscn")
const _YELLOW_ENEMY: PackedScene = preload("res://enemies/enemy_yellow.tscn")
const _PURPLE_ENEMY: PackedScene = preload("res://enemies/enemy_purple.tscn")
@export_category("objects")
@export var _wave_timer: Timer
@export var _wave_spawn_cooldown: Timer

var _wave_dict: Dictionary = {
  1: {
    "wave_time": 20,
    "wave_amount": 1,
    "wave_spawn_cooldown": 4,
    "spots_amount": [3, 6],
    "wave_difficulty": "easy",
  },
  2: {
    "wave_time": 25,
    "wave_amount": 2,
    "wave_spawn_cooldown": 5,
    "spots_amount": [2, 4],
    "wave_difficulty": "easy",
  }
}

var _current_wave: int = 1


func _ready() -> void:
  _wave_spawn_cooldown.start(_wave_dict[_current_wave]["wave_spawn_cooldown"])
  _wave_timer.start(_wave_dict[_current_wave]["wave_time"])
  _spawn_enemies()

  
func _spawn_enemies() -> void:
  var amount = _wave_dict[_current_wave]["wave_amount"]
  var spots: Array = []
  
  for children in get_children():
    if not children is Timer:
      spots.append(children)
    
  var spawn_spots: Array = []
  for quantity in amount:
    var index = randi() % spots.size()
    var selected_spot: Node2D = spots[index]
    spawn_spots.append(selected_spot)
    spots.remove_at(index)
    
  for spot in spawn_spots:
    var childrens: Array = []
    var selected_childrens: Array = []
    for children in spot.get_children():
      childrens.append(children)
    
    var amount_list:Array = _wave_dict[_current_wave]["spots_amount"]
    var selected_amount: int = randi_range(amount_list[0], amount_list[1])
    
    for selected in selected_amount:
      var index: int = randi() % childrens.size()
      var selected_spot: Node2D = childrens[index]
      selected_childrens.append(selected_spot)
      childrens.remove_at(index)
    
    for spawner in selected_childrens:
      _spawn_enemy(spawner)  
    
  
func _spawn_enemy(spawner: Node2D) -> void:
  var enemy: EnemyBase = null
  var random_number: float = randf()
  var difficulty: String = _wave_dict[_current_wave]["wave_difficulty"]
  match difficulty:
    "easy":
      enemy = _GREEN_ENEMY.instantiate() 
    "easy_to_medium":
      if random_number <= 0.7:
        enemy = _GREEN_ENEMY.instantiate()
      else:
        enemy = _YELLOW_ENEMY.instantiate()
    "medium": 
      if random_number <= 0.5:
        enemy = _GREEN_ENEMY.instantiate()
      else:
        enemy = _YELLOW_ENEMY.instantiate()
    "medium_to_hard":
      if random_number <= 0.4:
        enemy = _GREEN_ENEMY.instantiate()
      elif random_number > 0.4 and random_number <= 0.9:
        enemy = _YELLOW_ENEMY.instantiate()
      else:
        enemy = _PURPLE_ENEMY.instantiate()
    "hard":
      if random_number <= 0.2:
        enemy = _GREEN_ENEMY.instantiate()
      elif random_number > 0.2 and random_number <= 0.8:
        enemy = _YELLOW_ENEMY.instantiate()
      else:
        enemy = _PURPLE_ENEMY.instantiate()
      
  enemy.global_position = spawner.global_position
  get_parent().call_deferred("add_child", enemy)

     
func _on_wave_timer_timeout() -> void:
  _current_wave += 1
  if _current_wave > 10:
    print("You win")
    return
  _wave_timer.start(_wave_dict[_current_wave]["wave_time"])


func _on_wave_spawn_cooldown_timeout():
    _spawn_enemies()
    _wave_spawn_cooldown.start(_wave_dict[_current_wave]["wave_spawn_cooldown"])
