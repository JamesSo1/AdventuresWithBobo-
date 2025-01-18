extends Node

#Preload Obstacles
var porcupine_scene = preload("res://scenes/porcupine.tscn")
var redpanda_scene = preload("res://scenes/red_panda.tscn")
var chicken_scene = preload("res://scenes/chicken.tscn")
var bird_scene = preload("res://scenes/bird.tscn")
var obstacle_types := [porcupine_scene, redpanda_scene, chicken_scene]
var obstacles : Array
#How high the bird obstacles will spawn
var bird_heights = [200,390]

#Game Variables
const PLAYER_START_POS := Vector2i(150,485)
const CAM_START_POS := Vector2i(576,324)
var score : int
const SCORE_MODIFIER : int = 10
var speed : float
const SPEED_MODIFIER : int = 5000
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var difficulty = 0
const DIFFICULTY_MODIFIER = 1500
const MAX_DIFFICULTY : int = 2
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var last_obs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	#reset the variables
	score = 0
	show_score()
	game_running = false
	difficulty = 0
	
	#reset the nodes
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0,0)
	
	#reset HUD
	$HUD.get_node("StartLabel").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		print(difficulty)
		
		#Generate obstacles
		generate_obs()
		
		#Move player and camera
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		#Update score
		score += speed
		show_score()
		
		#Update ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
		
func generate_obs():
	#Generate ground obstacles
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300,500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i*100)
			var obs_y : int = screen_size.y - (ground_height) - (obs_height * obs_scale.y / 2)
			add_obs(obs, obs_x, obs_y)
		

func add_obs(obs, x, y):
	last_obs = obs
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
	
func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

func adjust_difficulty():
	#The difficulty increases by 1 level every 1500 points and the max difficulty is 2
	difficulty = (score / SCORE_MODIFIER) / DIFFICULTY_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY
		
