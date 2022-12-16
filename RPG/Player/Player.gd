extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100 
const FRICTION = 500

enum { #liste over variabler
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true


func _physics_process(delta): #innebyd funksjon som er relatert til fysikken i spillet
	match state:
		MOVE:
			move_state(delta) #Når man beveger seg kjører
		
		ROLL:
			pass
		
		ATTACK:
			attack_state(delta)
	
	

		
func move_state(delta): #funksjon for movement
	var input_vector = Vector2.ZERO #hvis "ui_right"- har en styrke på 1 og "ui_left"- har en styrke på 0, vil x-komponenten til input_vector settes til 1 - 0 = 1.
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #normaliserer jeg vector - lenge = 1
	
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector) #Run - Vector2.ZERO = Velocity(variabel)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) #matte for å regne ut velocity
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
