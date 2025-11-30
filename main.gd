extends Node

const DEFAULT_ENTITY: PackedScene = preload("res://entities/default_entity.tscn")

@onready var _entity: Entity = $Entity

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_handle_input()

func _handle_input() -> void:
	if !_entity || !is_instance_valid(_entity):
		_entity = _create_entity()
	else:
		_hit_entity(_entity)

func _create_entity() -> Entity:
	var new_entity: Entity = DEFAULT_ENTITY.instantiate() as Entity

	add_child(new_entity)

	return new_entity

func _hit_entity(entity: Entity) -> void:
	var _hit: Callable = entity.get_method(&"hurtbox_hit")
	if _hit:
		_hit.call(null, 1)
