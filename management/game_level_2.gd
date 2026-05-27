extends Node2D

var label = Label 
var last_subtraction_time = 0
var spawn_timer: float = 0.0
var fumace_timer: float = 0.0
@onready var cat_scene = preload("res://animals/cat.tscn")
@onready var fumace_scene = preload("res://trashs/fumace.tscn")
@onready var first_level_node = $first_level
@onready var dog = $dog
@export var time = Timer
@export var redclr : Color
@export var origClr : Color
@export var origClrbg : Color = Color(1, 1, 1, 1)
@onready var game_level: Node2D = $"."
@onready var player_light = $first_level/Mia/PointLight2D
@onready var hud = get_node("./UI/HUD")
@export var clockTIme := 0:  
	set(value):
		clockTIme = value
		hud.clock = clockTIme
# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("UI/HUD/Label");
	time = $Timer
	time.start()
	OriginClrRet()
	player_light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_label_text()
	
	if time.time_left <= 10:
		label.modulate = redclr
	else:
		OriginClrRet()
		
	var progress = time.time_left / time.wait_time
	game_level.modulate = Color(progress, progress, progress, 1)
	
	if progress < 0.5:  # Ajuste o valor conforme necessário
		player_light.visible = true
	else:
		player_light.visible = false
		
	# Lógica para aumentar o número de mosquitos com o tempo da fase
	var spawn_interval = max(1.0, progress * 8.0) # de 8s até 1s no final
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		var new_mosquito = cat_scene.instantiate()
		new_mosquito.position = Vector2(randf_range(0, 700), randf_range(0, 500))
		first_level_node.add_child(new_mosquito)
		
	# Lógica para aparecer o Fumacê de tempos em tempos (a cada 15 segundos)
	fumace_timer += delta
	if fumace_timer >= 15.0:
		fumace_timer = 0.0
		var novo_fumace = fumace_scene.instantiate()
		novo_fumace.position = Vector2(randf_range(50, 650), randf_range(50, 450))
		first_level_node.add_child(novo_fumace)
		
	if time.time_left <= 0.1 && int(hud.score.text) != 7:		
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
	if int(hud.score.text) == 7:
		get_tree().change_scene_to_file("res://nextLevel.tscn")
	
	if time.time_left <= 15:
		dog.move_to_position(Vector2(392, 72))
	
		last_subtraction_time += delta;
		
		if last_subtraction_time >= 5:
			if int(hud.score.text) > 0:
				hud.score.text = str(int(hud.score.text) - 1)				
					
			last_subtraction_time = 0
	
	
func OriginClrRet():
	label.modulate = origClr
	#game_level.modulate = origClrbg

func update_label_text():
	clockTIme = int(ceil(time.time_left))
