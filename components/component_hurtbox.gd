extends Node
class_name ComponentHurtbox
# I'd generally extend a node for
# but for demo purpose am shortcutting with simple method

@export var entity: Entity

signal got_hit(by: Entity, damage: int)

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.register_signal(&"got_hit", self)
	entity.register_method(&"hurtbox_hit", _hurtbox_hit)

func _hurtbox_hit(by: Entity, damage: int) -> void:
	got_hit.emit(by, 1)
