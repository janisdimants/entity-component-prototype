extends GPUParticles2D
class_name ComponentOnDeathParticles

@export var entity: Entity

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	emitting = false
	one_shot = true

	entity.connect_to_signal(ComponentHp.DIED, _on_died)


func _on_died() -> void:
	reparent(entity.get_parent(), true)
	emitting = true

	await finished
	queue_free()
