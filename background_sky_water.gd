extends ParallaxBackground


@export var scroll_speed = 50


func _process(delta):
	scroll_offset.x -= scroll_speed * delta
