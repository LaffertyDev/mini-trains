@tool

extends Area2D
class_name GridTile

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
	
func rotate_tile():
	match grid_type:
		Constants.GridType.RAIL_VERTICAL:
			pass
		Constants.GridType.RAIL_HORIZONTAL:
			pass
		Constants.GridType.RAIL_JUNCTION_90:
			match self.junction_type:
				Constants.JunctionType.EAST_SOUTH:
					self.junction_type = Constants.JunctionType.WEST_SOUTH
				Constants.JunctionType.WEST_SOUTH:
					self.junction_type = Constants.JunctionType.WEST_NORTH
				Constants.JunctionType.WEST_NORTH:
					self.junction_type = Constants.JunctionType.EAST_NORTH
				Constants.JunctionType.EAST_NORTH:
					self.junction_type = Constants.JunctionType.EAST_SOUTH
		Constants.GridType.RAIL_JUNCTION_X:
			if self.junction_type == Constants.JunctionType.HORIZONTAL:
				self.junction_type = Constants.JunctionType.VERTICAL
			elif self.junction_type == Constants.JunctionType.VERTICAL:
				self.junction_type = Constants.JunctionType.HORIZONTAL
	GlobalAudio.play_sound_rotate_junction()

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
		Constants.GridType.RAIL_JUNCTION_90:
			update_rail_junction()
		Constants.GridType.RAIL_JUNCTION_X:
			update_rail_junction()

func update_rail_junction() -> void:
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
