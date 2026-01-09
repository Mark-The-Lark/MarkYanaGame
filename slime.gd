extends Sprite2D

var tween: Tween
var og_scale = scale
var ratio = Vector2(1.1, 0.9)
var increase = true
var speed = randf_range(1, 2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = create_tween()
	tween.tween_property(self, "scale", og_scale*ratio,speed)
	tween.tween_property(self, "scale", og_scale/ratio,speed)
	tween.set_loops()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
