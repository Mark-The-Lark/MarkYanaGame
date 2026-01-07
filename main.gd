extends Node2D
@onready var enemy_scene: PackedScene = load("res://enemy.tscn")

var Enemys: Array[Enemy]
var spawn_radius = 1000
var wave = 1
@onready var cannon = $Base/Cannon

func spawnEnemy() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	var angle = (randf()-0.5)*2*PI
	enemy.global_position = Vector2(cos(angle), sin(angle))*spawn_radius + $Base.global_position
	self.add_child(enemy)
	enemy.killed.connect(removeEnemy)
	enemy.set_target($Base.global_position)
	Enemys.append(enemy)
	
func updateHealth(delta: int):
	$Base/HealthBar/ProgressBar.value = $Base.health
	

func _ready() -> void:
	$Base/HealthBar/ProgressBar.value = $Base.health
	$WaveBar/ProgressBar.value = 100
	$Base.damaged.connect(updateHealth)
	#$Cannon.global_position = $Base.collidable.global_position
	spawn_wave()

func removeEnemy(enemy: Enemy):
	Enemys.erase(enemy)
	$WaveBar/ProgressBar.value = 100*len(Enemys)/((wave-1)**2+wave)
	if !len(Enemys):
		spawn_wave()

func _physics_process(delta: float) -> void:
	if !cannon.target:
		cannon.aim(Enemys)
	else:
		cannon.fire(delta)

func spawn_wave():
	$WaveBar/Label.text = "Wave: " + str(wave)
	for i in range(wave**2+wave+1):
		spawnEnemy()
	wave+=1
