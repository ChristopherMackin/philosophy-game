extends Area3D

class_name AreaWithExceptions

@export var exceptions: Array[CollisionObject3D]

signal area_entered_without_exception(area: Area3D)
signal area_exited_without_exception(area: Area3D)
signal area_shape_entered_without_exception(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int)
signal area_shape_exited_without_exception(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int)
signal body_entered_without_exception(body: Node3D)
signal body_exited_without_exception(body: Node3D)
signal body_shape_entered_without_exception(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int)
signal body_shape_exited_without_exception(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int)


func _on_area_entered(area):
	if _check_for_exceptions(area): return
	area_entered_without_exception.emit(area)
	

func _on_area_exited(area):
	if _check_for_exceptions(area): return
	area_exited_without_exception.emit(area)

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if _check_for_exceptions(area): return
	area_shape_entered_without_exception.emit(area_rid, area, area_shape_index, local_shape_index)


func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if _check_for_exceptions(area): return
	area_shape_exited_without_exception.emit(area_rid, area, area_shape_index, local_shape_index)


func _on_body_entered(body):
	if _check_for_exceptions(body): return
	body_entered_without_exception.emit(body)


func _on_body_exited(body):
	if _check_for_exceptions(body): return
	body_exited_without_exception.emit(body)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if _check_for_exceptions(body): return
	body_shape_entered_without_exception.emit(body_rid, body, body_shape_index, local_shape_index)


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if _check_for_exceptions(body): return
	body_shape_exited_without_exception.emit(body_rid, body, body_shape_index, local_shape_index)

func _check_for_exceptions(collision_body: CollisionObject3D):
	for exception in exceptions:
		if exception == collision_body:
			return true
	
	return false
