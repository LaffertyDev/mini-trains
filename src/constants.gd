class_name Constants
enum GridType {
	EMPTY,
	TRACK,
	BLOCKED_INVISIBLE,
}

enum RailType { 
	HORIZONTAL = 0,
	VERTICAL = 1,
	EAST_SOUTH = 2,
	WEST_SOUTH = 3,
	WEST_NORTH = 4,
	EAST_NORTH = 5,
	CROSS_HORIZONTAL = 6,
	CROSS_VERTICAL = 7
}

enum GuiControlMode {
	NONE,
	TRACK
}

enum Direction {left, top, bottom, right}

const GRID_TILE_SIZE_PIXELS: int = 16
