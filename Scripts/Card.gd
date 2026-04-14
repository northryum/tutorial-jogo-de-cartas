extends Node2D

signal hovered
signal hovered_off


func _ready() -> void:
	# todas as cartas devem ser filhas de Cards_Manager
	get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	pass # Replace with function body.
