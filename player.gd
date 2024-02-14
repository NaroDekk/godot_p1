extends Area2D

@export var speed = 400
@export var roll_speed = speed * 1.5

var _current_state = states.MOVE

var screen_size

enum states {
	MOVE,
	ROLL
}

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		return;
	
	if _current_state == states.MOVE:
		if event.is_action_pressed("roll"):
			_current_state = states.ROLL

func _physics_process(delta):
	match _current_state:
		states.MOVE:
			move(delta)
		states.ROLL:
			roll()
