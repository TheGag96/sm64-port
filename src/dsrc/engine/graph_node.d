module engine.graph_node;

import ultra64, types, game.memory, game.area, gbi;

import core.stdc.stdint;

extern (C):

enum GRAPH_RENDER_ACTIVE = 1 << 0;
enum GRAPH_RENDER_CHILDREN_FIRST = 1 << 1;
enum GRAPH_RENDER_BILLBOARD = 1 << 2;
enum GRAPH_RENDER_Z_BUFFER = 1 << 3;
enum GRAPH_RENDER_INVISIBLE = 1 << 4;
enum GRAPH_RENDER_HAS_ANIMATION = 1 << 5;

// Whether the node type has a function pointer of type GraphNodeFunc
enum GRAPH_NODE_TYPE_FUNCTIONAL = 0x100;

// Type used for Bowser and an unused geo function in obj_behaviors.c
enum GRAPH_NODE_TYPE_400 = 0x400;

// The discriminant for different types of geo nodes
enum GRAPH_NODE_TYPE_ROOT = 0x001;
enum GRAPH_NODE_TYPE_ORTHO_PROJECTION = 0x002;
enum GRAPH_NODE_TYPE_PERSPECTIVE = 0x003 | GRAPH_NODE_TYPE_FUNCTIONAL;
enum GRAPH_NODE_TYPE_MASTER_LIST = 0x004;
enum GRAPH_NODE_TYPE_START = 0x00A;
enum GRAPH_NODE_TYPE_LEVEL_OF_DETAIL = 0x00B;
enum GRAPH_NODE_TYPE_SWITCH_CASE = 0x00C | GRAPH_NODE_TYPE_FUNCTIONAL;
enum GRAPH_NODE_TYPE_CAMERA = 0x014 | GRAPH_NODE_TYPE_FUNCTIONAL;
enum GRAPH_NODE_TYPE_TRANSLATION_ROTATION = 0x015;
enum GRAPH_NODE_TYPE_TRANSLATION = 0x016;
enum GRAPH_NODE_TYPE_ROTATION = 0x017;
enum GRAPH_NODE_TYPE_OBJECT = 0x018;
enum GRAPH_NODE_TYPE_ANIMATED_PART = 0x019;
enum GRAPH_NODE_TYPE_BILLBOARD = 0x01A;
enum GRAPH_NODE_TYPE_DISPLAY_LIST = 0x01B;
enum GRAPH_NODE_TYPE_SCALE = 0x01C;
enum GRAPH_NODE_TYPE_SHADOW = 0x028;
enum GRAPH_NODE_TYPE_OBJECT_PARENT = 0x029;
enum GRAPH_NODE_TYPE_GENERATED_LIST = 0x02A | GRAPH_NODE_TYPE_FUNCTIONAL;
enum GRAPH_NODE_TYPE_BACKGROUND = 0x02C | GRAPH_NODE_TYPE_FUNCTIONAL;
enum GRAPH_NODE_TYPE_HELD_OBJ = 0x02E | GRAPH_NODE_TYPE_FUNCTIONAL;
enum GRAPH_NODE_TYPE_CULLING_RADIUS = 0x02F;

// The number of master lists. A master list determines the order and render
// mode with which display lists are drawn.
enum GFX_NUM_MASTER_LISTS = 8;

// Passed as first argument to a GraphNodeFunc to give information about in
// which context it was called and what it is expected to do.
enum GEO_CONTEXT_CREATE = 0; // called when node is created from a geo command
enum GEO_CONTEXT_RENDER = 1; // called from rendering_graph_node.c
enum GEO_CONTEXT_AREA_UNLOAD = 2; // called when unloading an area
enum GEO_CONTEXT_AREA_LOAD = 3; // called when loading an area
enum GEO_CONTEXT_AREA_INIT = 4; // called when initializing the 8 areas
enum GEO_CONTEXT_HELD_OBJ = 5; // called when processing a GraphNodeHeldObj

// The signature for a function stored in a geo node
// The context argument depends on the callContext:
// - for GEO_CONTEXT_CREATE it is the AllocOnlyPool from which the node was allocated
// - for GEO_CONTEXT_RENDER or GEO_CONTEXT_HELD_OBJ it is the top of the float matrix stack with type Mat4
// - for GEO_CONTEXT_AREA_* it is the root geo node
alias GraphNodeFunc = Gfx* function (int callContext, GraphNode* node, void* context);

/** An extension of a graph node that includes a function pointer.
 *  Many graph node types have an update function that gets called
 *  when they are processed.
 */
struct FnGraphNode
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    GraphNodeFunc func;
}

/** The very root of the geo tree. Specifies the viewport.
 */
struct GraphNodeRoot
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    ubyte areaIndex;
    /*0x15*/
    byte unk15; // ?
    /*0x16*/
    short x;
    /*0x18*/
    short y;
    /*0x1A*/
    short width; // half width, 160
    /*0x1C*/
    short height; // half height
    /*0x1E*/
    short numViews; // number of entries in mystery array
    /*0x20*/
    GraphNode** views;
}

/** A node that sets up an orthographic projection based on the global
 *  root node. Used to draw the skybox image.
 */
struct GraphNodeOrthoProjection
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    f32 scale;
}

/** A node that sets up a perspective projection. Used for drawing the
 *  game world. It does not set up the camera position, that is done by
 *  the child of this node, which has type GraphNodeCamera.
 */
struct GraphNodePerspective
{
    /*0x00*/
    FnGraphNode fnNode;
    /*0x18*/
    int unused;
    /*0x1C*/
    f32 fov; // horizontal field of view in degrees
    /*0x20*/
    short near; // near clipping plane
    /*0x22*/
    short far; // far clipping plane
}

/** An entry in the master list. It is a linked list of display lists
 *  carrying a transformation matrix.
 */
struct DisplayListNode
{
    Mtx* transform;
    void* displayList;
    DisplayListNode* next;
}

/** GraphNode that manages the 8 top-level display lists that will be drawn
 *  Each list has its own render mode, so for example water is drawn in a
 *  different master list than opaque objects.
 *  It also sets the z-buffer on before rendering and off after.
 */
struct GraphNodeMasterList
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    DisplayListNode*[GFX_NUM_MASTER_LISTS] listHeads;
    /*0x34*/
    DisplayListNode*[GFX_NUM_MASTER_LISTS] listTails;
}

/** Simply used as a parent to group multiple children.
 *  Does not have any additional functionality.
 */
struct GraphNodeStart
{
    /*0x00*/
    GraphNode node;
}

/** GraphNode that only renders its children if the current transformation matrix
 *  has a z-translation (in camera space) greater than minDistance and less than
 *  maxDistance.
 *  Usage examples: Mario has three level's of detail: Normal, low-poly arms only, and fully low-poly
 *  The tower in Whomp's fortress has two levels of detail.
 */
struct GraphNodeLevelOfDetail
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    short minDistance;
    /*0x16*/
    short maxDistance;
}

/** GraphNode that renders exactly one of its children.
 *  Which one is rendered is determined by the field 'selectedCase'
 *  which is set in the node's function.
 *  Usage examples: room visibility, coin animation, blinking, Mario's power-up / hand pose / cap
 */
struct GraphNodeSwitchCase
{
    /*0x00*/
    FnGraphNode fnNode;
    /*0x18*/
    int unused;
    /*0x1C*/
    short numCases;
    /*0x1E*/
    short selectedCase;
}

/**
 * GraphNode that specifies the location and aim of the camera.
 * When the roll is 0, the up vector is (0, 1, 0).
 */
struct GraphNodeCamera
{
    /*0x00*/
    FnGraphNode fnNode;
    /*0x18*/
    // When the node is created, a mode is assigned to the node.
    // Later in geo_camera_main a Camera is allocated,
    // the mode is passed to the struct, and the field is overridden
    // by a pointer to the struct. Gotta save those 4 bytes.
    union _Anonymous_0
    {
        int mode;
        struct Camera;
        Camera* camera;
    }

    _Anonymous_0 config;
    /*0x1C*/
    Vec3f pos;
    /*0x28*/
    Vec3f focus;
    /*0x34*/
    Mat4* matrixPtr; // pointer to look-at matrix of this camera as a Mat4
    /*0x38*/
    short roll; // roll in look at matrix. Doesn't account for light direction unlike rollScreen.
    /*0x3A*/
    short rollScreen; // rolls screen while keeping the light direction consistent
}

/** GraphNode that translates and rotates its children.
 *  Usage example: wing cap wings.
 *  There is a dprint function that sets the translation and rotation values
 *  based on the ENEMYINFO array.
 *  The display list can be null, in which case it won't draw anything itself.
 */
struct GraphNodeTranslationRotation
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
    /*0x18*/
    Vec3s translation;
    /*0x1E*/
    Vec3s rotation;
}

/** GraphNode that translates itself and its children.
 *  Usage example: SUPER MARIO logo letters in debug level select.
 *  The display list can be null, in which case it won't draw anything itself.
 */
struct GraphNodeTranslation
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
    /*0x18*/
    Vec3s translation;
    ubyte[2] pad1E;
}

/** GraphNode that rotates itself and its children.
 *  Usage example: Mario torso / head rotation. Its parameters are dynamically
 *  set by a parent script node in that case.
 *  The display list can be null, in which case it won't draw anything itself.
 */
struct GraphNodeRotation
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
    /*0x18*/
    Vec3s rotation;
    ubyte[2] pad1E;
}

/** GraphNode part that transforms itself and its children based on animation
 *  data. This animation data is not stored in the node itself but in global
 *  variables that are set when object nodes are processed if the object has
 *  animation.
 *  Used for Mario, enemies and anything else with animation data.
 *  The display list can be null, in which case it won't draw anything itself.
 */
struct GraphNodeAnimatedPart
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
    /*0x18*/
    Vec3s translation;
}

/** A GraphNode that draws a display list rotated in a way to always face the
 *  camera. Note that if the entire object is a billboard (like a coin or 1-up)
 *  then it simply sets the billboard flag for the entire object, this node is
 *  used for billboard parts (like a chuckya or goomba body).
 */
struct GraphNodeBillboard
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
    /*0x18*/
    Vec3s translation;
}

/** A GraphNode that simply draws a display list without doing any
 *  transformation beforehand. It does inherit the parent's transformation.
 */
struct GraphNodeDisplayList
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
}

/** GraphNode part that scales itself and its children.
 *  Usage example: Mario's fist or shoe, which grows when attacking. This can't
 *  be done with an animated part sine animation data doesn't support scaling.
 *  Note that many scaling animations (like a goomba getting stomped) happen on
 *  the entire object. This node is only used when a single part needs to be scaled.
 *  There is also a level command that scales the entire level, used for THI.
 *  The display list can be null, in which case it won't draw anything itself.
 */
struct GraphNodeScale
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    void* displayList;
    /*0x18*/
    f32 scale;
}

/** GraphNode that draws a shadow under an object.
 *  Every object starts with a shadow node.
 *  The shadow type determines the shape (round or rectangular), vertices (4 or 9)
 *  and other features.
 */
struct GraphNodeShadow
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    short shadowScale; // diameter (when a circle) or side (when a square) of shadow
    /*0x16*/
    ubyte shadowSolidity; // opacity of shadow, 255 = opaque
    /*0x17*/
    ubyte shadowType; // see ShadowType enum in shadow.h
}

/** GraphNode that contains as its sharedChild a group node containing all
 *  object nodes.
 */
struct GraphNodeObjectParent
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    GraphNode* sharedChild;
}

/** GraphNode that draws display lists not directly in memory but generated by
 *  a function.
 *  Used for wobbling paintings, water, environment effects.
 *  It might not draw anything, it could also just update something.
 *  For example: there is a node that stops water flow when the game is paused.
 *  The parameter field gives extra context info. For shifting sand or paintings,
 *  it can determine which texture to use.
 */
struct GraphNodeGenerated
{
    /*0x00*/
    FnGraphNode fnNode;
    /*0x18*/
    uint parameter; // extra context for the function
}

/** GraphNode that draws a background image or a rectangle of a color.
 *  Drawn in an orthographic projection, used for skyboxes.
 */
struct GraphNodeBackground
{
    /*0x00*/
    FnGraphNode fnNode;
    /*0x18*/
    int unused;
    /*0x1C*/
    int background; // background ID, or rgba5551 color if fnNode.func is null
}

/** Renders the object that Mario is holding.
 */
struct GraphNodeHeldObject
{
    /*0x00*/
    FnGraphNode fnNode;
    /*0x18*/
    int playerIndex;
    /*0x1C*/
    Object* objNode;
    /*0x20*/
    Vec3s translation;
}

/** A node that allows an object to specify a different culling radius than the
 *  default one of 300. For this to work, it needs to be a direct child of the
 *  object node. Used for very large objects, such as shock wave rings that Bowser
 *  creates, tornadoes, the big eel.
 */
struct GraphNodeCullingRadius
{
    /*0x00*/
    GraphNode node;
    /*0x14*/
    short cullingRadius; // specifies the 'sphere radius' for purposes of frustum culling
    ubyte[2] pad1E;
}

extern __gshared GraphNodeMasterList* gCurGraphNodeMasterList;
extern __gshared GraphNodePerspective* gCurGraphNodeCamFrustum;
extern __gshared GraphNodeCamera* gCurGraphNodeCamera;
extern __gshared GraphNodeHeldObject* gCurGraphNodeHeldObject;
extern __gshared ushort gAreaUpdateCounter;

extern __gshared GraphNode* gCurRootGraphNode;
extern __gshared GraphNode*[] gCurGraphNodeList;

extern __gshared short gCurGraphNodeIndex;

extern __gshared Vec3f gVec3fZero;
extern __gshared Vec3s gVec3sZero;
extern __gshared Vec3f gVec3fOne;
extern __gshared Vec3s gVec3sOne;

void init_scene_graph_node_links (GraphNode* graphNode, int type);

GraphNodeRoot* init_graph_node_root (
    AllocOnlyPool* pool,
    GraphNodeRoot* graphNode,
    short areaIndex,
    short x,
    short y,
    short width,
    short height);
GraphNodeOrthoProjection* init_graph_node_ortho_projection (AllocOnlyPool* pool, GraphNodeOrthoProjection* graphNode, f32 scale);
GraphNodePerspective* init_graph_node_perspective (
    AllocOnlyPool* pool,
    GraphNodePerspective* graphNode,
    f32 fov,
    short near,
    short far,
    GraphNodeFunc nodeFunc,
    int unused);
GraphNodeStart* init_graph_node_start (AllocOnlyPool* pool, GraphNodeStart* graphNode);
GraphNodeMasterList* init_graph_node_master_list (AllocOnlyPool* pool, GraphNodeMasterList* graphNode, short on);
GraphNodeLevelOfDetail* init_graph_node_render_range (
    AllocOnlyPool* pool,
    GraphNodeLevelOfDetail* graphNode,
    short minDistance,
    short maxDistance);
GraphNodeSwitchCase* init_graph_node_switch_case (
    AllocOnlyPool* pool,
    GraphNodeSwitchCase* graphNode,
    short numCases,
    short selectedCase,
    GraphNodeFunc nodeFunc,
    int unused);
GraphNodeCamera* init_graph_node_camera (
    AllocOnlyPool* pool,
    GraphNodeCamera* graphNode,
    f32* pos,
    f32* focus,
    GraphNodeFunc func,
    int mode);
GraphNodeTranslationRotation* init_graph_node_translation_rotation (
    AllocOnlyPool* pool,
    GraphNodeTranslationRotation* graphNode,
    int drawingLayer,
    void* displayList,
    Vec3s translation,
    Vec3s rotation);
GraphNodeTranslation* init_graph_node_translation (
    AllocOnlyPool* pool,
    GraphNodeTranslation* graphNode,
    int drawingLayer,
    void* displayList,
    Vec3s translation);
GraphNodeRotation* init_graph_node_rotation (
    AllocOnlyPool* pool,
    GraphNodeRotation* graphNode,
    int drawingLayer,
    void* displayList,
    Vec3s rotation);
GraphNodeScale* init_graph_node_scale (
    AllocOnlyPool* pool,
    GraphNodeScale* graphNode,
    int drawingLayer,
    void* displayList,
    f32 scale);
GraphNodeObject* init_graph_node_object (
    AllocOnlyPool* pool,
    GraphNodeObject* graphNode,
    GraphNode* sharedChild,
    Vec3f pos,
    Vec3s angle,
    Vec3f scale);
GraphNodeCullingRadius* init_graph_node_culling_radius (AllocOnlyPool* pool, GraphNodeCullingRadius* graphNode, short radius);
GraphNodeAnimatedPart* init_graph_node_animated_part (
    AllocOnlyPool* pool,
    GraphNodeAnimatedPart* graphNode,
    int drawingLayer,
    void* displayList,
    Vec3s translation);
GraphNodeBillboard* init_graph_node_billboard (
    AllocOnlyPool* pool,
    GraphNodeBillboard* graphNode,
    int drawingLayer,
    void* displayList,
    Vec3s translation);
GraphNodeDisplayList* init_graph_node_display_list (
    AllocOnlyPool* pool,
    GraphNodeDisplayList* graphNode,
    int drawingLayer,
    void* displayList);
GraphNodeShadow* init_graph_node_shadow (
    AllocOnlyPool* pool,
    GraphNodeShadow* graphNode,
    short shadowScale,
    ubyte shadowSolidity,
    ubyte shadowType);
GraphNodeObjectParent* init_graph_node_object_parent (
    AllocOnlyPool* pool,
    GraphNodeObjectParent* sp1c,
    GraphNode* sharedChild);
GraphNodeGenerated* init_graph_node_generated (
    AllocOnlyPool* pool,
    GraphNodeGenerated* sp1c,
    GraphNodeFunc gfxFunc,
    int parameter);
GraphNodeBackground* init_graph_node_background (
    AllocOnlyPool* pool,
    GraphNodeBackground* sp1c,
    ushort background,
    GraphNodeFunc backgroundFunc,
    int zero);
GraphNodeHeldObject* init_graph_node_held_object (
    AllocOnlyPool* pool,
    GraphNodeHeldObject* sp1c,
    Object* objNode,
    Vec3s translation,
    GraphNodeFunc nodeFunc,
    int playerIndex);
GraphNode* geo_add_child (GraphNode* parent, GraphNode* childNode);
GraphNode* geo_remove_child (GraphNode* graphNode);
GraphNode* geo_make_first_child (GraphNode* newFirstChild);

void geo_call_global_function_nodes_helper (GraphNode* graphNode, int callContext);
void geo_call_global_function_nodes (GraphNode* graphNode, int callContext);

void geo_reset_object_node (GraphNodeObject* graphNode);
void geo_obj_init (GraphNodeObject* graphNode, void* sharedChild, Vec3f pos, Vec3s angle);
void geo_obj_init_spawninfo (GraphNodeObject* graphNode, SpawnInfo* spawn);
void geo_obj_init_animation (GraphNodeObject* graphNode, Animation** animPtrAddr);
void geo_obj_init_animation_accel (GraphNodeObject* graphNode, Animation** animPtrAddr, uint animAccel);

int retrieve_animation_index (int frame, ushort** attributes);

short geo_update_animation_frame (AnimInfo* obj, int* accelAssist);
void geo_retreive_animation_translation (GraphNodeObject* obj, Vec3f position);

GraphNodeRoot* geo_find_root (GraphNode* graphNode);

// graph_node_manager
short* read_vec3s_to_vec3f (Vec3f, short* src);
short* read_vec3s (Vec3s dst, short* src);
short* read_vec3s_angle (Vec3s dst, short* src);
void register_scene_graph_node (GraphNode* graphNode);

// GRAPH_NODE_H