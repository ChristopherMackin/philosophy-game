extends GraphEdit

func _on_delete_nodes_request(nodes):
	for n in nodes:
		get_node(NodePath(n)).queue_free()
