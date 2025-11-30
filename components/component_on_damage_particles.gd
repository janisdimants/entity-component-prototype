extends GPUParticles2D
class_name ComponentOnDamageParticles

@export var entity: Entity

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	emitting = false
	one_shot = true
	entity.connect_to_signal(&"took_damage", _on_took_damage)

func _on_took_damage(_damage: int) -> void:
	restart()
	emitting = true
