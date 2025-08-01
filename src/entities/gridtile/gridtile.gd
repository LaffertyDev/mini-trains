@tool

extends Area2D

@export var grid_type: Constants.GridType = Constants.GridType.EMPTY:
	set(new_resource):
		grid_type = new_resource
		set_image()
@export var junction_type: Constants.JunctionType = Constants.JunctionType.HORIZONTAL:
	set(new_resource):
		junction_type = new_resource
		set_image()

var horizontal = load('res://src/entities/gridtile/rail_horizontal.png')
var vertical = load('res://src/entities/gridtile/rail_vertical.png')

func _ready():
	add_to_group("grid_tiles")
	set_image()

func set_image():
	%junction_sprite.hide()
	%sprite.hide()
	match grid_type:
		Constants.GridType.RAIL_VERTICAL:
			%sprite.texture = vertical
			%sprite.show()
			%left.monitorable = true
			%right.monitorable = true
			%top.monitorable = false
			%bottom.monitorable = false
		Constants.GridType.RAIL_HORIZONTAL:
			%sprite.texture = horizontal
			%sprite.show()
			%left.monitorable = false
			%right.monitorable = false
			%top.monitorable = true
			%bottom.monitorable = true
		Constants.GridType.RAIL_JUNCTION:
			%junction_sprite.stop()
			%junction_sprite.show()
			%junction_sprite.frame = junction_type
			match self.junction_type:
				Constants.JunctionType.HORIZONTAL:
					%left.monitorable = false
					%right.monitorable = false
					%top.monitorable = true
					%bottom.monitorable = true
				Constants.JunctionType.VERTICAL:
					%left.monitorable = true
					%right.monitorable = true
					%top.monitorable = false
					%bottom.monitorable = false
				Constants.JunctionType.EAST_SOUTH:
					%left.monitorable = true
					%right.monitorable = false
					%top.monitorable = true
					%bottom.monitorable = false
				Constants.JunctionType.EAST_NORTH:
					%left.monitorable = true
					%right.monitorable = false
					%top.monitorable = false
					%bottom.monitorable = true
				Constants.JunctionType.WEST_SOUTH:
					%left.monitorable = false
					%right.monitorable = true
					%top.monitorable = true
					%bottom.monitorable = false
				Constants.JunctionType.WEST_NORTH:
					%left.monitorable = false
					%right.monitorable = true
					%top.monitorable = false
					%bottom.monitorable = true
