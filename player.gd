extends Area2D
signal hit

@export var speed = 400
var screen_size
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = action_pressed(delta)
	animation(velocity)
	
func action_pressed(delta: float) -> Vector2:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite_2d.play()
	else:
		animated_sprite_2d.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	return velocity;
	

func animation(velocity: Vector2) -> void:
	if velocity.x != 0:
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_v = false
		animated_sprite_2d.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite_2d.animation = "up"
		animated_sprite_2d.flip_v = velocity.y > 0

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	collision_shape_2d.set_deferred("disabled", true)
	
func start(pos):
	position = pos;
	show()
	collision_shape_2d.disabled = false	
	
