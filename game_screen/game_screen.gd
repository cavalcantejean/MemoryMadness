extends Control

@export var new_tile_scene: PackedScene

@onready var moves_label: Label = $HB/MC2/VBoxContainer/HB/MovesLabel
@onready var pass_label: Label = $HB/MC2/VBoxContainer/HB2/PassLabel

@onready var sound: AudioStreamPlayer = $Sound
@onready var tile_container: GridContainer = $HB/MC1/TileContainer
@onready var scorer: Scorer = $Scorer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_level_selected.connect(on_level_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moves_label.text = scorer.get_moves_made_str()
	pass_label.text = scorer.get_pairs_made_str()

func add_memory_tile(ii_dict: Dictionary, frame_image: CompressedTexture2D) -> void:
	var new_tile = new_tile_scene.instantiate()
	tile_container.add_child(new_tile)
	new_tile.setup(ii_dict, frame_image)

func on_level_selected(level_num: int) -> void:
	var level_selection = GameManager.get_level_selection(level_num)
	var frame_image = ImageManager.get_random_frame_image()
	
	tile_container.columns = level_selection.num_cols
	
	for ii_dict in level_selection.image_list:
		add_memory_tile(ii_dict, frame_image)
		
	scorer.clear_new_game(level_selection.target_pairs)


func _on_exit_button_pressed() -> void:
	for t in tile_container.get_children():
		t.queue_free()
	SoundManager.play_button_click(sound)
	SignalManager.on_game_exit_pressed.emit()
