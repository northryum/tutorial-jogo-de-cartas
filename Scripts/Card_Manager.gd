extends Node2D

var COLISION_MASK_CARD = 1

var card_being_dragged
var screen_size
var is_hovering_on_card

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
		 clamp(mouse_pos.y, 0, screen_size.y))
	pass

func _input(_event):
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT:
		if _event.is_pressed():
			var card = _rayCast_check_for_card()
			if card:
				_start_drag(card)
		else:
			finish_frag()
	pass

func _start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

func finish_frag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	card_being_dragged = null

func connect_card_signals(_card):
	_card.connect("hovered", _on_hovered_ever_card)
	_card.connect("hovered_off", _on_hovered_off_card)

func _on_hovered_ever_card(_card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		_highlight_card(_card, true)

func _on_hovered_off_card(_card):
	if !card_being_dragged:
		#is_hovering_on_card = false
		_highlight_card(_card, false)
		# checando se esta hovered off diretamente para outra carta
		var new_card_hovered = _rayCast_check_for_card()
		if new_card_hovered:
			_highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func _highlight_card(_card, hovered):
	if hovered:
		_card.scale = Vector2(1.05, 1.05)
		_card.z_index = 2
	else:
		_card.scale = Vector2(1, 1)
		_card.z_index = 1

func _rayCast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return _get_card_with_highest_z_index(result)
	return null

func _get_card_with_highest_z_index(_cards):
	var highest_z_card = _cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, _cards.size()):
		var current_card = _cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
