extends Node

func update(resource : Resource):
	ResourceSaver.save(resource, resource.resource_path)
