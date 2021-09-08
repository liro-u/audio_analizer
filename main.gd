extends Node2D

onready var visualizer=$"main/visualizer"

func pic_color(i):
	var color=Color(0,0,0)
	if i==1 or i==2 or i==5 or i==6:
		color.r=255
	if i==1 or i==4 or i==6 or i==7:
		color.g=255
	if i==1 or i==3 or i==5 or i==7:
		color.b=255
	return color

func _on_TextEdit_text_changed(new_text):
	if int(new_text)>0:
		visualizer.definition=int(new_text)

func _on_ColorPickerButton_color_changed(color):
	$"main/ColorRect".show()
	$"main/TextureRect".hide()
	$"main/VideoPlayer".hide()
	$"main/TextureRect2".hide()
	$"main/ColorRect".color=color


func _on_OptionButton_item_selected(index):
	$"main/Particles2D".process_material.color=pic_color(index)
	
func _on_OptionButton2_item_selected(index):
	visualizer.col=pic_color(index)


func _on_LineEdit_text_changed(new_text):
	$"main".volume_db=int(new_text)
	
func _on_L2ineEdit_text_changed(new_text):
	if int(new_text)>0:
		visualizer.size_line=float(new_text)
		visualizer.show()
	else:
		visualizer.hide()


func _on_Button_pressed():
	$"CanvasLayer/Control".hide()
	visualizer.start()

func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, file.READ)
	var buffer = file.get_buffer(file.get_len())
	var new_stream = AudioStreamSample.new()
	for i in 200:
		buffer.remove(buffer.size()-1)
		buffer.remove(0)
	new_stream.data = buffer
	new_stream.format = 1
	new_stream.mix_rate = 44100
	new_stream.stereo = true
	file.close()
	
	$"main".stream=new_stream
	



func _on_Button_pressed_2():
	$"CanvasLayer/FileDialog".popup()






func _on_FileDialog3_file_selected(path):
	$"main/VideoPlayer".show()
	$"main/TextureRect2".show()
	$"main/TextureRect".hide()
	$"main/ColorRect".hide()
	$"main/VideoPlayer".stream=load(path)



func _on_Button_pressed8():
	$"CanvasLayer/FileDialog3".popup()


func _on_LineEdi_text_changed(new_text):
	$"main/VideoPlayer".volume_db=int(new_text)


func _on_m_toggled(button_pressed):
	if button_pressed:
		$"main".set_bus("Master")
	else:
		$"main".set_bus("bin")


func _on_v_toggled(button_pressed):
	if button_pressed:
		$"main/VideoPlayer".set_bus("Master")
	else:
		$"main/VideoPlayer".set_bus("bin")


func _on_CheckButn_toggled(button_pressed):
	$"main/VideoPlayer".loop_video=button_pressed


func _on_Button_image_pressed():
	$"CanvasLayer/FileDialog2".popup()


func _on_FileDialog2_file_selected(path):
	$"main/ColorRect".hide()
	$"main/VideoPlayer".hide()
	$"main/TextureRect2".hide()
	$"main/TextureRect".show()
	var tex = ImageTexture.new()
	var img = Image.new()
	img.load(path)
	tex.create_from_image(img)
	$"main/TextureRect".texture = tex
