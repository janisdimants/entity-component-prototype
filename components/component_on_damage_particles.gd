extends GPUParticles2D
class_name ComponentOnDamageParticles

@export var entity: Entity

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	emitting = false
	one_shot = true

	entity.connect_to_signal(ComponentHp.GOT_DAMAGED, _on_got_damaged)


func _on_got_damaged(_damage: int) -> void:
	restart()
	emitting = true
