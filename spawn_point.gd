extends Sprite2D

@export var player:PackedScene 
func _ready() -> void:
	spawn()

func spawn():
	var p=player.instantiate()
	add_child(p)
	pass
