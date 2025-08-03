extends Node

func get_grid_controller() -> GridController:
	var tree = get_tree()
	if tree:
		var grid_controllers = tree.get_nodes_in_group("grid_controller")
		assert(grid_controllers.size() == 1, "Invalid State")
		if grid_controllers[0] is GridController:
			return grid_controllers[0]
	return null

func get_game_controller() -> GameController:
	var tree = get_tree()
	if tree:
		var game_controllers = tree.get_nodes_in_group("game_controller")
		assert(game_controllers.size() == 1, "Invalid State")
		if game_controllers[0] is GameController:
			return game_controllers[0]
	return null
