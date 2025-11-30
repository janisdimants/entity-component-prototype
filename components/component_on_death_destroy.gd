extends Node2D
class_name ComponentOnDeathDestroy

@export var entity: Entity

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.connect_to_signal(ComponentHp.DIED, _on_died)


func _on_died() -> void:
	entity.queue_free()
