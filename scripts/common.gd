extends Node

func get_animation_duration_of_sprite(sprite: AnimatedSprite2D, animation: String) -> float:
	var sprite_frames: SpriteFrames = sprite.sprite_frames
	var frame_count = sprite_frames.get_frame_count(animation)
	
	var duration: float = 0
	for i in range(frame_count):
		duration += sprite_frames.get_frame_duration(animation,i)
	
	return duration / (sprite_frames.get_animation_speed(animation) * sprite.speed_scale)
