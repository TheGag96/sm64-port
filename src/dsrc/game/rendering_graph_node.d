module game.rendering_graph_node;

import ultra64, types, engine.graph_node, gbi;

extern (C):

extern __gshared GraphNodeRoot* gCurGraphNodeRoot;
extern __gshared GraphNodeMasterList* gCurGraphNodeMasterList;
extern __gshared GraphNodePerspective* gCurGraphNodeCamFrustum;
extern __gshared GraphNodeObject* gCurGraphNodeObject;
extern __gshared GraphNodeHeldObject* gCurGraphNodeHeldObject;

// after processing an object, the type is reset to this
enum ANIM_TYPE_NONE                  = 0;

// Not all parts have full animation: to save space, some animations only
// have xz, y, or no translation at all. All animations have rotations though
enum ANIM_TYPE_TRANSLATION           = 1;
enum ANIM_TYPE_VERTICAL_TRANSLATION  = 2;
enum ANIM_TYPE_LATERAL_TRANSLATION   = 3;
enum ANIM_TYPE_NO_TRANSLATION        = 4;

// Every animation includes rotation, after processing any of the above
// translation types the type is set to this
enum ANIM_TYPE_ROTATION              = 5;

void geo_process_node_and_siblings(GraphNode* firstNode);
void geo_process_root(GraphNodeRoot* node, Vp* b, Vp* c, s32 clearColor);