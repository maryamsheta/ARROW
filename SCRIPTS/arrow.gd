extends Node2D

var directions = [0,90,180,270]
var allowedKeys = [KEY_DOWN,KEY_LEFT,KEY_UP,KEY_RIGHT]
var score = 0
var lives = []
var press = true
var end   = false
var start = false

func _ready():
	lives = [$LIVE3,$LIVE2,$LIVE1]
	reset()
	
func _input(event):
	if start:
		if event is InputEventKey and event.pressed and press:
			if event.keycode in allowedKeys:
				$AnimationPlayer.play("scale")	
				if event.keycode == get_key($ARROW.rotation_degrees):
					score+=1
					$SCORE.text = "SCORE: " + str(score)
					$SFXPlayer.stream = preload("res://SFX/Success.mp3") 
					$SFXPlayer.play()
				else:
					if !lives.is_empty():
						lives[0].visible = false
						lives.pop_front()
						$SFXPlayer.stream = preload("res://SFX/LoseHeart.mp3") 
						$SFXPlayer.play()
				press = false
				reset() 


func _process(delta):	
	if !start and Input.is_key_pressed(KEY_SPACE):
		start = true
		$ARROW.visible = true
		$START.visible = false
		$SFXPlayer.stream = preload("res://SFX/Start.mp3") 
		$SFXPlayer.play()
	
	
	if lives.is_empty():
		$GAMEOVER.visible = true
		$TITLE.text = "[center]PRESS R\nTO RESTART[/center]"
		press = false
		
	if end:
		$SFXPlayer.play()
		press = false

	if Input.is_key_pressed(KEY_R):
		$SFXPlayer.stream = preload("res://SFX/Start.mp3") 
		$SFXPlayer.play()
		reload_scene()
	
func correct_key():
	var key = get_key($ARROW.rotation_degrees)
	return key in allowedKeys and Input.is_key_pressed(key)

func get_key(direction):
	if direction == 0: return KEY_DOWN
	if direction == 90: return KEY_LEFT
	if direction == 180: return KEY_UP
	if direction == 270: return KEY_RIGHT
	return KEY_UNKNOWN
	
func reset():
	press = true
	var direction = directions.pick_random()
	$ARROW.rotation_degrees = direction
	
func reload_scene():
	await get_tree().create_timer(0.9).timeout
	get_tree().reload_current_scene()


