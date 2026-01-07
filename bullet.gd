extends Node2D
class_name Bullet

var damage
var speed
var target: Enemy
@onready var body = $RigidBody2D


func set_target(tgt: Enemy):
	target = tgt
	
func kill():
	self.get_parent().remove_child(self)
	
func _physics_process(delta: float) -> void:
	if target.dead:
		kill()
	var pos = body.global_position
	var napr = target.get_future_pos() - pos
	napr /= napr.length()
	body.set_axis_velocity(napr*speed)
	body.rotation = PI + napr.angle()
