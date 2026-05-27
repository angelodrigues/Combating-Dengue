extends SceneTree
func _init():
	var scene = load('res://animals/cat.tscn')
	var packed = scene.instantiate()
	var anim = packed.get_node('anim')
	var tex = load('res://animals/mosquito.png')
	if not tex:
		print('ERROR: COULD NOT LOAD MOSQUITO.PNG')
		quit()
		return
	var sf = anim.sprite_frames
	for anim_name in sf.get_animation_names():
		sf.clear(anim_name)
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(0, 0, 32, 32)
		sf.add_frame(anim_name, atlas)
	var new_scene = PackedScene.new()
	new_scene.pack(packed)
	ResourceSaver.save(new_scene, 'res://animals/cat.tscn')
	print('DONE')
	quit()
