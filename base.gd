extends Node2D
class_name Base

@onready var collidable = $RigidBody2D
var health = 100

func _ready() -> void:
	collidable.body_entered.connect(on_body_entered)
	collidable.freeze = true
	
signal damaged(value: int)

func on_body_entered(body: Node):
	var parent = body.get_parent()
	if parent is Enemy:
		health -= parent.damage
		damaged.emit(parent.damage)
		parent.kill()
