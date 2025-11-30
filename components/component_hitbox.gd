extends Area2D
class_name ComponentHitbox

@export var entity: Entity
@export var damage: int = 1

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)
