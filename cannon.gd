extends Node2D
class_name Cannon

var bullet_scene = load("res://bullet.tscn")
var firerate = 1
var loading = 0
var damage = 50
var speed = 200
var target: Enemy

func unaim():
	target = null

func aim(targets: Array[Enemy]):
	if !len(targets):
		return
	var chosen = targets[0]
	var pos = self.global_position
	for enemy in targets:
		if (enemy.body.global_position-pos).length() < (chosen.body.global_position-pos).length():
			chosen = enemy
	target = chosen
	target.killed.connect(unaim)
	loading = 0
	
func fire(delta: float):
	if !target:
		return
		
		
	var pos = self.global_position
	rotation = PI/2+(target.get_pos()-pos).angle()
	loading += delta
	if loading > 1/firerate:
		var bullet = bullet_scene.instantiate()
		bullet.position = Vector2(0,0)
		bullet.damage = damage
		bullet.speed = speed
		self.get_parent().add_child(bullet)
		bullet.set_target(target)
		unaim()
		loading = 0
