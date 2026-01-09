extends Node2D
class_name Enemy

var dead = false
var damage = 10
var speed = 50
var max_health = 10
var health = 10
var target: Vector2 = Vector2(0,0)
@onready var body = $RigidBody2D



signal killed(enemy: Enemy)

func set_target(pos: Vector2) -> void:
	target = pos
func deal_damage(dmg: float):
	health -= dmg
	$RigidBody2D/HealthBar/ProgressBar.value = health
func pushme(power: float):
	var pos = body.global_position
	var napr = target - pos
	napr /= napr.length()
	body.apply_force(-napr*power)

func kill():
	dead = true
	killed.emit(self)
	get_parent().remove_child(self)
	queue_free()

func _ready() -> void:
	$RigidBody2D/HealthBar/ProgressBar.max_value = max_health
	$RigidBody2D/HealthBar/ProgressBar.value = health
	
func get_pos() -> Vector2:
	return body.global_position
func get_future_pos() -> Vector2:
	var pos = body.global_position
	var napr = target - pos
	napr /= napr.length()
	return body.global_position + napr*speed*get_physics_process_delta_time()

func _physics_process(delta: float) -> void:
	if health <= 0:
		kill()
	var pos = body.global_position
	var napr = target - pos
	napr /= napr.length()
	body.set_axis_velocity(napr*speed)
	
