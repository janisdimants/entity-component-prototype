extends Node

const DEFAULT_ENTITY: PackedScene = preload("res://entities/default_entity.tscn")

@onready var _entity: Entity = $Entity

var _entities: Array[Entity] = []

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_handle_input()

	if event.is_pressed() && event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			_entity = _create_entity()
			_entity.position = event.position

func _handle_input() -> void:
	if !_entity || !is_instance_valid(_entity):
		_entity = _create_entity()
	else:
		_hit_entity(_entity)

func _create_entity() -> Entity:
	var new_entity: Entity = DEFAULT_ENTITY.instantiate() as Entity

	add_child(new_entity)

	_entities.push_back(new_entity)
	new_entity.connect_to_signal(&"died", _entities.erase.bind(new_entity))

	return new_entity

func _hit_entity(entity: Entity) -> void:
	var _hit: Callable = entity.get_method(&"hurtbox_hit")
	if _hit:
		_hit.call(null, 1)

func _physics_process(delta: float) -> void:
	for _entity: Entity in _entities:
		var _set_move_input: Callable = _entity.get_method(&"set_move_input")
		if !_set_move_input:
			continue

		var _closest_entity: Entity = _find_closest_entity(_entity)
		if !_closest_entity:
			_set_move_input.call(Vector2())
			continue

		var _position_delta: Vector2 = _closest_entity.position - _entity.position
		_set_move_input.call(_position_delta)

func _find_closest_entity(find_entity: Entity) -> Entity:
	var _closest_entity: Entity
	var _closest_distance: float = INF

	for _entity: Entity in _entities:
		if _entity == find_entity:
			continue

		var distance: float = find_entity.position.distance_to(_entity.position)
		if distance < _closest_distance:
			_closest_entity = _entity
			_closest_distance = distance

	return _closest_entity
