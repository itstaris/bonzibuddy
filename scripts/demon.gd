extends CharacterBody3D

@export var speed : float
@export var acceleration : float

@onready var nav : NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	var direction = Vector3()
	
	nav.target_position = Global.target.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed , acceleration * delta)
	
	move_and_slide()
