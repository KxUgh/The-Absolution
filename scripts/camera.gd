extends Camera2D

@export var player: Node2D
@export var stiffness: float
@export var horizontal_pan_distance: float
@export var vertical_pan_distance: float

@onready var pan_distance: Vector2 = Vector2(horizontal_pan_distance,vertical_pan_distance)

func _physics_process(delta: float) -> void:
	var viewport_size: Vector2 = get_viewport_rect().size / zoom
	
	# mouse position is within range [-viewport_size / 2 , viewport_size / 2]
	var min_mouse_position: Vector2 = -viewport_size / 2
	var max_mouse_position: Vector2 = viewport_size / 2
	
	var mouse_position: Vector2 = get_local_mouse_position().clamp(min_mouse_position,max_mouse_position)
	
	var normalized_mouse_position: Vector2 = mouse_position * 2 / viewport_size
	
	var desired_position: Vector2 = player.position + normalized_mouse_position * pan_distance
	
	position += (desired_position - position) * stiffness * delta
