extends Node2D
class_name Enemy

var dead = false
var damage = 10
var speed = 100
var max_health = 100
var health = 100
var target: Vector2 = Vector2(0,0)
@onready var body = $RigidBody2D


signal killed(enemy: Enemy)

func set_target(pos: Vector2) -> void:
	target = pos

func kill():
	dead = true
	killed.emit(self)
	self.get_parent().remove_child(self)

func _ready() -> void:
	$RigidBody2D/HealthBar/ProgressBar.max_value = max_health
	$RigidBody2D/HealthBar/ProgressBar.value = health
	body.body_entered.connect(on_body_entered)
	
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
	
func on_body_entered(body: Node):
	var parent = body.get_parent()
	if parent is Bullet:
		health -= parent.damage
		$RigidBody2D/HealthBar/ProgressBar.value = health
		parent.kill()
