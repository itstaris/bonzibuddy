extends CharacterBody3D

@onready var nav = $NavigationAgent3D
@onready var player: Node3D = get_parent().get_node("player")

var speed = 4.0
var gravity = 9.8


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
	
func target_position(target):
	nav.target_position = target
