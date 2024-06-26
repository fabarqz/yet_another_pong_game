extends Node2D

#member variables
var screen_size
var pad_size
var direction = Vector2(1.0,0.0)

const INITIAL_BALL_SPEED=80
var ball_speed=INITIAL_BALL_SPEED
const PAD_SPEED =150

func _ready():
	screen_size=get_viewport_rect().size
	pad_size=get_node("left_paddle").get_texture().get_size()
	set_process(true)

func _process(delta):
	var ball_pos=get_node("ball").get_position()
	var left_rect=Rect2(get_node("left_paddle").get_position()-pad_size*0.5,pad_size)
	var right_rect=Rect2(get_node("right_paddle").get_position()-pad_size*0.5,pad_size)
	
	#integrate new ball position
	ball_pos+=direction*ball_speed*delta
	
	#bounce when touching roof or floor
	if ((ball_pos.y<0 and direction.y<0)or(ball_pos.y>screen_size.y and direction.y>0)):
		direction.y=-direction.y
	
	if((left_rect.has_point(ball_pos) and direction.x<0)or (right_rect.has_point(ball_pos) and direction.x>0)):
		direction.x=-direction.x
		direction.y=randf()*2.0-1
		direction=direction.normalized()
		ball_speed*=1.1
		
	if(ball_pos.x<0 or ball_pos.x>screen_size.x):
		ball_pos=screen_size*0.5
		ball_speed=INITIAL_BALL_SPEED
		direction=Vector2(-1,0)
	
	get_node("ball").set_position(ball_pos)
	
	var left_pos=get_node("left_paddle").get_position()
	
	#left_paddle movement
	if(left_pos.y>0 and Input.is_action_pressed("left_move_up")):
		left_pos.y+=-PAD_SPEED*delta
	if(left_pos.y<screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y+=PAD_SPEED*delta
		
	get_node("left_paddle").set_position(left_pos)
	
	#right paddle control	
	var right_pos=get_node("right_paddle").get_position()
	if(ball_pos.y<right_pos.y and right_pos.y>0):
		right_pos.y-=PAD_SPEED*delta
	elif(ball_pos.y>right_pos.y and right_pos.y<screen_size.y):
		right_pos.y+=PAD_SPEED*delta
		
	
	get_node("right_paddle").set_position(right_pos)

