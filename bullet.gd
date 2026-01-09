extends Node2D
class_name Bullet

var damage
var speed
var power = 50
var target: Enemy
@onready var body = $RigidBody2D

func _ready() -> void:
	body.body_entered.connect(on_body_entered)

func set_target(tgt: Enemy):
	target = tgt
	
func kill():
	queue_free()
	
func _physics_process(delta: float) -> void:
	if !target:
		kill()
		return
	var pos = body.global_position
	var napr = target.get_future_pos() - pos
	napr /= napr.length()
	body.set_axis_velocity(napr*speed)
	#body.rotation = PI + napr.angle()

func on_body_entered(body: Node):
	var parent = body.get_parent()
	if parent is Enemy:
		parent.deal_damage(damage)
		parent.pushme(power*speed)
		kill()
