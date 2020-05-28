package ceramic;

import tracker.Model;

class Tileset extends Model {

    /** First global id. Maps to the first tile in this tileset. */
    @serialize public var firstGid:Int = -1;

    /** The name of this tileset */
    @serialize public var name:String = null;

    /** The (maximum) width of tiles in this tileset */
    @serialize public var tileWidth:Int = -1;

    /** The (maximum) height of tiles in this tileset */
    @serialize public var tileHeight:Int = -1;

    /** The spacing between tiles in this tileset */
    @serialize public var spacing:Int = 0;

    /** The margin around the tiles in this tileset */
    @serialize public var margin:Int = 0;

    /** The number of tiles in this tileset */
    @serialize public var tileCount:Int = 0;

    /** The number of tile columns in this tileset */
    @serialize public var columns:Int = 0;

    /** Horizontal offset. Used to specify an offset to be applied when drawing a tile. */
    @serialize public var tileOffsetX:Int = 0;

    /** Vertical offset. Used to specify an offset to be applied when drawing a tile. */
    @serialize public var tileOffsetY:Int = 0;

    /** The image used to display tiles in this tileset */
    @serialize public var image:TilesetImage = null;

    /** Orientation of the grid for the tiles in this tileset.
        Only used in case of isometric orientation,
        to determine how tile overlays for terrain an collision information are rendered. */
    @serialize public var gridOrientation:TilesetGridOrientation = ORTHOGONAL;

    /** Width of a grid cell.
        Only used in case of isometric orientation,
        to determine how tile overlays for terrain an collision information are rendered. */
    @serialize public var gridCellWidth:Int = 0;

    /** Height of a grid cell.
        Only used in case of isometric orientation,
        to determine how tile overlays for terrain an collision information are rendered. */
    @serialize public var gridCellHeight:Int = 0;

}
