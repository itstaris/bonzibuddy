extends CharacterBody3D

@onready var nav = $NavigationAgent3D
@onready var area = $Area3D
@onready var player: Node3D = get_parent().get_node("player")

@onready var footstep_player: AudioStreamPlayer3D = $footstep

var step_timer := 0.0
@export var step_interval := 0.5  # tempo entre passos
@export var min_velocity := 0.1   # movimento mínimo pra considerar que está andando

var speed = 4.0
var gravity = 9.8

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()

func _process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 2
	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * speed
	
	var dir = player.global_position - global_position
	dir.y = 0
	if dir.length_squared() > 0.0001:
		look_at(global_position + dir, Vector3.UP)
	
	velocity = velocity.move_toward(new_velocity,0.25)
	move_and_slide()
	footstep_player.play
	
func target_position(target):
	nav.target_position = target
	
func _physics_process(delta):
	# lógica de movimento do inimigo (já existente)
	if velocity.length() > min_velocity:
		step_timer -= delta
		if step_timer <= 0.0:
			
			step_timer = step_interval
		else:
			step_timer = 0.0  # reseta se parou

#func play_footstep():
	#if footstep_player.playing:
		#footstep_player.stop()
	#footstep_player.play()
