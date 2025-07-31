extends CharacterBody2D

@onready var sprite = $Sprite
@export var loop_frame_amount: int = 120
@export var max_loops: int = 5
@export var speed: float = 125
@export var gravity: float = 400
@export var jump_power: float = 170
var recoded_frame_inputs = []
var current_loop_frame: int = 0
var loop_count = 0
func _ready() -> void:
	
	pass

func _physics_process(delta: float) -> void:
	if loop_count == 0:
		var current_input = []
		if Input.is_action_pressed("Left"): current_input.append("Left")
		if Input.is_action_pressed("Right"): current_input.append("Right")
		if Input.is_action_pressed("Jump"): current_input.append("Jump")
		recoded_frame_inputs.append(current_input)
		play_input(delta,current_input)
		if loop_frame_amount == recoded_frame_inputs.size(): 
			loop_count = 1
			get_tree().call_group("Player_Spawner", "spawn")
	else:
		play_input(delta,recoded_frame_inputs[current_loop_frame])
		current_loop_frame = (current_loop_frame+1)%loop_frame_amount
		if current_loop_frame == 0: 
			loop_count += 1
			if loop_count >= max_loops: queue_free()
		
	move_and_slide()
	pass

func play_input(delta:float,inputs: Array) -> void:
	var input_axis =Vector2.ZERO
	for input in inputs:
		match (input):
			"Left":
				input_axis.x -=1
			"Right":
				input_axis.x +=1
			"Jump":
				if is_on_floor(): jump()
	if input_axis.x == 1: sprite.flip_h = false
	elif input_axis.x == -1: sprite.flip_h = true
	velocity.x = input_axis.x*speed
	velocity.y += gravity*delta

func jump():
	velocity.y = -jump_power
