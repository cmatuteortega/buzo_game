extends Area2D

func _on_body_entered(_body): 
	queue_free() # Replace with function body.
	Events.bubble_picked.emit()
