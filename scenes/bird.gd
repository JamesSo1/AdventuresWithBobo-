extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_meta("type", "bird")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Makes the bird move to the left
	position.x -= get_parent().speed / 5
