extends Node3D
@export var stirSpeed: float = 2
var mouseEntered = false
var prevMousePos

func _process(delta: float) -> void:
	if mouseEntered and Input.is_action_pressed("Select"):
		StirLadel()
	if Input.is_action_just_released("Select"):
		mouseEntered = false
		$"..".isStirring = false
	prevMousePos = get_viewport().get_mouse_position()
	pass

func _on_area_3d_mouse_entered() -> void:
	mouseEntered = true
	pass # Replace with function body.



func StirLadel():
	var delta = prevMousePos - get_viewport().get_mouse_position()
	if delta.x < 0:
		delta.x = - delta.x
	if delta.y < 0:
		delta.y = - delta.y
	$".".rotate_y(((delta.x+delta.y)/333.00))
	if delta.x > stirSpeed:
		$"..".isStirring = true
	else:
		$"..".isStirring = false
	pass
