extends CharacterBody3D

#@export var speed : float
#@export var acceleration : float
#
#@onready var nav : NavigationAgent3D = $NavigationAgent3D
#
#func _physics_process(delta):
	#var direction = Vector3()
	#
	#nav.target_position = Global.target.global_position
	#
	#direction = nav.get_next_path_position() - global_position
	#direction = direction.normalized()
	#
	#velocity = velocity.lerp(direction * speed , acceleration * delta)
	#
	#move_and_slide()

@export var speed := 4.0
@export var detection_distance := 20.0
@export var target_node : NodePath = "../player"

var player: Node3D
var is_chasing := false

@onready var agent := $NavigationAgent3D

func _ready():
	player = get_node(target_node)
	agent.target_desired_distance = 1.0
	agent.path_desired_distance = 0.5

func _physics_process(delta):
	if not player:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Simula visão com raycast manual (ou pode usar RayCast3D)
	if distance <= detection_distance:
		var space_state = get_world_3d().direct_space_state
		var ray_params = PhysicsRayQueryParameters3D.new()
		ray_params.from = global_position
		ray_params.to = player.global_position
		ray_params.exclude = [self]
		ray_params.collision_mask = collision_mask
		
		var result = space_state.intersect_ray(ray_params)
		
		
		
		#var result = space_state.intersect_ray({
		#	"from": global_position,
		#	"to": player.global_position,
		#	"exclude": [self],
		#	"collision_mask": collision_mask
		#})

		if result and result.collider == player:
			if not is_chasing:
				is_chasing = true
				agent.set_target_position(player.global_position)
		else:
			is_chasing = false

	# Se está perseguindo, atualiza o target e move
	if is_chasing:
		agent.set_target_position(player.global_position)
		agent.set_velocity(Vector3.ZERO) # pra forçar novo cálculo
		#agent.update()  # força atualização
		var next_path = agent.get_next_path_position()
		var move_direction = (next_path - global_position).normalized()
		velocity = move_direction * speed
		move_and_slide()
