extends Area2D
class_name ComponentHurtbox

const GOT_HIT: StringName = &"got_hit"

@export var entity: Entity
@export var overlapping_timer: float = 0.2

signal got_hit(by: Entity, damage: int)

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.register_signal(GOT_HIT, self)
	entity.register_method(&"hurtbox_hit", _hurtbox_hit)

	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is ComponentHitbox:
		if area.entity != entity:
			_hurtbox_hit(area.entity, area.damage)
			_test_still_overlapping(area)


func _test_still_overlapping(hitbox: ComponentHitbox) -> void:
	await get_tree().create_timer(overlapping_timer).timeout
	if overlaps_area(hitbox):
		_hurtbox_hit(hitbox.entity, hitbox.damage)
		_test_still_overlapping(hitbox)


func _hurtbox_hit(by: Entity, damage: int) -> void:
	got_hit.emit(by, 1)
