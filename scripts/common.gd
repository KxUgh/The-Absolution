extends Node

func get_animation_duration_of_sprite(sprite: AnimatedSprite2D, animation: String) -> float:
	var sprite_frames: SpriteFrames = sprite.sprite_frames
	var frame_count = sprite_frames.get_frame_count(animation)
	
	var duration: float = 0
	for i in range(frame_count):
		duration += sprite_frames.get_frame_duration(animation,i)
	
	return duration / (sprite_frames.get_animation_speed(animation) * sprite.speed_scale)

func play_sprite_animation_duration(sprite: AnimatedSprite2D, animation: String, duration: float = 0):
	var time_scale: float
	if duration == 0:
		time_scale = 1
	else:
		var animation_duration: float = get_animation_duration_of_sprite(sprite, animation)
		time_scale = animation_duration / duration
	sprite.play(animation, time_scale)
