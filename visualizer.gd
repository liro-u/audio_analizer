extends Node2D


onready var spectrum=AudioServer.get_bus_effect_instance(0, 0)

export var definition=20
export var tot_w=600
export var tot_h=200
export var min_f=20
export var max_f=20000
export(Color) var col
export var size_line=4.0
export var tempo=50


onready var particle_node=$"../Particles2D"

var max_db=-15
var min_db=-55
var histogram=[]

func _ready():
	set_process(false)
	set_process_input(false)

func start():
	max_db=-15
	min_db=-55
	set_process(true)
	set_process_input(true)
	particle_node.process_material.initial_velocity=tempo
	particle_node.lifetime=15*(50.0/float(tempo))
	max_db+=get_parent().volume_db
	min_db+=get_parent().volume_db
	
	for _i in range(definition):
		histogram.append(0)
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_parent().playing=true
		if $"../VideoPlayer".stream!=null:
			$"../VideoPlayer".no_texture = true
			$"../VideoPlayer".play()
	if event.is_action_pressed("ui_cancel"):
		get_parent().playing=false
		$"../VideoPlayer".stop()
		$"../../CanvasLayer/Control".show()
		set_process(false)
		set_process_input(false)
	
func _process(_delta):
	var freq=min_f
	var interval= (max_f-min_f)/definition
	
	for i in range(definition):
		var f_low=float(freq-min_f)/float(max_f-min_f)
		f_low=f_low
		f_low=lerp(min_f,max_f,f_low)
		
		freq+=interval
		
		var f_higth=float(freq-min_f)/float(max_f-min_f)
		f_higth=f_higth
		f_higth=lerp(min_f,max_f,f_higth)
		
		var mag=spectrum.get_magnitude_for_frequency_range(f_low,f_higth)
		mag=linear2db(mag.length())
		mag=(mag-min_db)/(max_db-min_db)
		mag=clamp(mag,0.05,1)
		histogram[i]=mag

	update()
		
func _draw():
	
	var draw_pos=Vector2(0,0)
	var w_interval=tot_w/definition
	
	if (len(histogram)!=0):
		for i in range(definition):
			draw_line(draw_pos, draw_pos+Vector2(0,-histogram[i]*tot_h),col,size_line,true)
			draw_line(draw_pos, draw_pos+Vector2(0,histogram[i]*tot_h),col,size_line,true)
			draw_line(Vector2(-draw_pos.x,draw_pos.y), Vector2(-draw_pos.x,draw_pos.y)+Vector2(0,histogram[i]*tot_h),col,size_line,true)
			draw_line(Vector2(-draw_pos.x,draw_pos.y), Vector2(-draw_pos.x,draw_pos.y)+Vector2(0,-histogram[i]*tot_h),col,size_line,true)
			draw_pos.x+=w_interval
