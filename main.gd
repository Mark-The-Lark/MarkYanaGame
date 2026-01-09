extends Node2D
@onready var enemy_scene: PackedScene = load("res://enemy.tscn")
@onready var emine_scene: PackedScene = load("res://emine.tscn")

var Enemys: Array[Enemy]
var spawn_radius = 1000
var meta_progress = 0
var wave = 1
@onready var cannon = $Base/Cannon

func spawnEnemy(radius: float) -> void:
	var rand = randi_range(0,1)
	var enemy: Enemy
	if rand == 0:
		enemy = enemy_scene.instantiate()
	else:
		enemy = emine_scene.instantiate()
		enemy.speed *= 1.5
		enemy.max_health *= 2
		enemy.health *= 2
	enemy.speed *= (meta_progress+1)
	enemy.max_health *= (meta_progress+1)
	enemy.health *= (meta_progress+1)
	var angle = (randf()-0.5)*2*PI
	enemy.global_position = Vector2(cos(angle), sin(angle))*radius + $Base.position
	self.add_child(enemy)
	enemy.killed.connect(removeEnemy)
	enemy.set_target($Base.global_position)
	Enemys.append(enemy)
	
func updateHealth(delta: float):
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

func _process(delta: float) -> void:
	if !cannon.target:
		cannon.aim(Enemys)
	else:
		cannon.fire(delta)

func spawn_wave():
	$WaveBar/Label.text = "Wave: " + str(wave)
	for i in range(wave**2+wave+1):
		spawnEnemy(spawn_radius+i*50)
	wave+=1
	meta_progress += log(1+wave/5.0)
