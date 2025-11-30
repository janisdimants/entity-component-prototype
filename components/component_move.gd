extends Node
class_name ComponentMove

const SET_MOVE_INPUT: StringName = &"set_move_input"
const KNOCKBACK: StringName = &"knockback"

@export var entity: Entity

var _velocity: Vector2 = Vector2()

@export var move_speed: float = 10.0
@export var acceleration: float = 2.0
@export var drag: float = 1.0
@export var move_input: Vector2 = Vector2()

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.register_method(SET_MOVE_INPUT, _set_move_input)
	entity.register_method(KNOCKBACK, knockback)

	entity.connect_to_signal(ComponentHurtbox.GOT_HIT, _on_got_hit)


func _set_move_input(input: Vector2) -> void:
	move_input = input.limit_length()


func _on_got_hit(by: Entity, _damage: int) -> void:
	var knockback_amount: float = 20.0
	if by is Entity:
		knockback((entity.position - by.position).normalized() * knockback_amount)


func knockback(value: Vector2) -> void:
	_velocity += value


func _physics_process(delta: float) -> void:
	_velocity -= _velocity.limit_length(drag)

	if _velocity.length() <= move_speed:
		_velocity += move_input * (acceleration + drag)
		_velocity = _velocity.limit_length(move_speed)

	entity.position += _velocity
