class_name Constants
enum GridType {
	EMPTY,
	RAIL_HORIZONTAL,
	RAIL_VERTICAL,
	RAIL_JUNCTION_X,
	RAIL_JUNCTION_90,
	BLOCKED_INVISIBLE,
}

enum JunctionType { 
	EAST_SOUTH = 0,
	WEST_SOUTH = 1,
	WEST_NORTH = 2,
	EAST_NORTH = 3,
	HORIZONTAL = 4,
	VERTICAL = 5
}

enum Direction {left, top, bottom, right}

const GRID_TILE_SIZE_PIXELS: int = 16
