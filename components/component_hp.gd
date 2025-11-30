extends Node
class_name ComponentHp

const HP_CHANGED: StringName = &"hp_changed"
const GOT_DAMAGED: StringName = &"got_damaged"
const DIED: StringName = &"died"
const DAMAGE: StringName = &"damage"
const SET_HP: StringName = &"set_hp"

@export var entity: Entity

@export var hp: int = 5:
	set(value):
		hp = value
		hp_changed.emit(value)

signal hp_changed(hp: int)
signal got_damaged(damage: int)
signal died()

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.register_signal(HP_CHANGED, self)
	entity.register_signal(GOT_DAMAGED, self)
	entity.register_signal(DIED, self)

	entity.register_method(SET_HP, set_hp)
	entity.register_method(DAMAGE, damage)

	entity.connect_to_signal(ComponentHurtbox.GOT_HIT, _on_got_hit)

	hp_changed.emit(hp)


func damage(_damage: int) -> void:
	if hp <= 0:
		# Already dead
		return

	hp -= _damage

	if hp <= 0:
		died.emit()
	else:
		got_damaged.emit(_damage)


func set_hp(value: int) -> void:
	hp = value
	hp_changed.emit(value)


func _on_got_hit(_by: Entity, _damage: int) -> void:
	damage(_damage)
