extends Node
class_name ComponentHp

@export var entity: Entity

@export var hp: int = 5:
	set(value):
		hp = value
		hp_changed.emit(value)

signal hp_changed(hp: int)
signal took_damage(damage: int)
signal died()

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.register_signal(&"hp_changed", self)
	entity.register_signal(&"took_damage", self)
	entity.register_signal(&"died", self)

	entity.register_method(&"take_damage", take_damage)

	entity.connect_to_signal(&"got_hit", _on_got_hit)

	hp_changed.emit(hp)

func take_damage(damage: int) -> void:
	if hp <= 0:
		# Already dead
		return

	hp -= damage

	if hp <= 0:
		died.emit()
	else:
		took_damage.emit(damage)

func _on_got_hit(_by: Entity, damage: int) -> void:
	take_damage(damage)
