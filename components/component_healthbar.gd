extends Node2D
class_name ComponentHealthbar

@export var entity: Entity

const HP_SIZE: int = 32.0

var _hp: int = 0

func _ready() -> void:
	if !entity && get_parent() is Entity:
		entity = get_parent()
	assert(entity)

	entity.connect_to_signal(ComponentHp.HP_CHANGED, _on_hp_changed)


func _on_hp_changed(hp: int) -> void:
	_hp = hp
	queue_redraw()


func _draw() -> void:
	for i: int in range(0, _hp):
		var _size: Vector2 = Vector2(HP_SIZE, HP_SIZE)
		var _position: Vector2 = Vector2(HP_SIZE * i, 0)
		var _rect: Rect2 = Rect2(_position, _size)
		draw_rect(_rect, Color.GREEN)
