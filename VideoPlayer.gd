extends VideoPlayer

var loop_video = true
var no_texture = true

func _process(delta):
	if is_playing() == false:
		if loop_video == true:
			play()
	if no_texture == true:
		if stream_position > 0 :
			no_texture = true
			var img = get_video_texture().get_data()
			var tex =ImageTexture.new()
			tex.create_from_image(img)
			$"../TextureRect2".texture = tex

