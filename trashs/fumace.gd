extends Area2D

@export var can_be_picked: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#try_pick_up()
	pass # Replace with function body.




var player_inside = null

func _on_body_entered(body: Mia) -> void: 	
	player_inside = body

func _on_body_exited(body: Mia) -> void:
	if body == player_inside:
		player_inside = null

func _process(delta: float) -> void:
	if player_inside and player_inside.hasGarb:
		if "fumace_count" in player_inside:
			player_inside.fumace_count += 1
		else:
			player_inside.set("fumace_count", 1)
			
		print("Fumacê coletado! Total na mochila: ", player_inside.get("fumace_count"))
		queue_free()
