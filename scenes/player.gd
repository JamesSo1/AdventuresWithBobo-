extends CharacterBody2D

#const GRAVITY : int = 5500
#const JUMP_SPEED : int = -1650

const GRAVITY : int = 9000
const JUMP_SPEED : int = -1650

#Called every frame, 'delta' is the elapsed time since the previous frame
func _physics_process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("Idle")
		else:
			#Note that DuckCol is contained inside the area of RunCol
			$RunCol.disabled = false
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
				$JumpSound.play()
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("Duck")
				$RunCol.disabled = true
			else:
				$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Jump")
	move_and_slide()
