extends CharacterBody2D
class_name cat

var direction: Vector2
var wait_time: float
@export_category("Variables")
@export var _move_speed: float = 50.0
@export_category("Objects")
@export var sprit2d = AnimatedSprite2D
@onready var animation := $anim as AnimatedSprite2D
@export var walk_timer: Timer

func _ready() -> void:
	wait_time = randf_range(5.0,15.0)
	direction = _get_direction()
	walk_timer.start(wait_time)
var steal_cooldown: float = 0.0

func _physics_process(delta: float) -> void:
	if steal_cooldown > 0:
		steal_cooldown -= delta

	velocity = direction *_move_speed
	move_and_slide()
	if get_slide_collision_count()> 0:
		var collision = get_slide_collision(0)
		var collider = collision.get_collider()
		
		# Se bater na Mia (o jogador) e o cooldown tiver zerado, rouba tempo!
		if collider is Mia and steal_cooldown <= 0:
			steal_cooldown = 2.0 # 2 segundos de intervalo antes de poder roubar de novo
			var game_level = get_tree().current_scene
			if game_level and game_level.has_node("Timer"):
				var timer = game_level.get_node("Timer")
				var new_time = timer.time_left - 2.0
				timer.start(new_time if new_time > 0.1 else 0.1)
				
		direction = velocity.bounce(
			collision.get_normal()
		).normalized()
	_animate(velocity)
	
	
func _animate(_velocity : Vector2) -> void:
	if velocity == Vector2.ZERO:
		animation.play("idle")
		return
		
	if velocity.x > 0 and velocity.y == 0:
		sprit2d.flip_h = true  
		animation.play("walking_right")

	elif velocity.x < 0 and velocity.y == 0:
		sprit2d.flip_h = false  
		animation.play("walking_left")

	elif velocity.y > 0 and velocity.x == 0:
		animation.play("walking_down")
		
	elif velocity.y < 0 and velocity.x == 0:
		animation.play("walking_up")
		
	elif _velocity.x > 0 and _velocity.y > 0:  # Diagonal inferior direita
		sprit2d.flip_h = true
		animation.play("diag_down_rigth")
		
	elif _velocity.x < 0 and _velocity.y > 0:
		sprit2d.flip_h = false
		animation.play("diag_down_left")
	elif _velocity.x > 0 and _velocity.y < 0:
		sprit2d.flip_h = true
		animation.play("diag_up_rigth")
	elif _velocity.x < 0 and _velocity.y < 0:
		sprit2d.flip_h = false
		animation.play("diag_up_left")
		
func _get_direction() -> Vector2:
	return [
		Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(0,-1),
		Vector2(1,-1), Vector2(-1,1), Vector2(0,1), Vector2(1,1),
		Vector2.ZERO
	].pick_random().normalized()


func _on_walk_timer_timeout() -> void:
	walk_timer.start(wait_time)
	if direction == Vector2.ZERO:
		direction = _get_direction()
		return
	direction = Vector2.ZERO
