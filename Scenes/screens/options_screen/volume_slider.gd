extends HSlider

@export var audio_bus_name = "Master"
@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
	Settings.settings["volume"] = value
	
func _reset() -> void:
	value = Settings.settings["volume"]
