module actors.common1;

import ultra64, types, util, gbi;

extern (C):

// blue_fish
mixin externCArray!(const(GeoLayout), "fish_shadow_geo");
mixin externCArray!(const(GeoLayout), "fish_geo");
mixin externCArray!(const(Gfx), "blue_fish_seg3_dl_0301BEC0");
mixin externCArray!(const(Gfx), "blue_fish_seg3_dl_0301BFB8");
mixin externCArray!(const(Gfx), "blue_fish_seg3_dl_0301C0A8");
mixin externCArray!(const(Gfx), "blue_fish_seg3_dl_0301C150");
mixin externCArray!(const(Animation*), "blue_fish_seg3_anims_0301C2B0");

// bowser_key
mixin externCArray!(const(GeoLayout), "bowser_key_geo");
mixin externCArray!(const(GeoLayout), "bowser_key_cutscene_geo");
mixin externCArray!(const(Gfx), "bowser_key_dl");
mixin externCArray!(const(Animation*), "bowser_key_seg3_anims_list");

// butterfly
mixin externCArray!(const(GeoLayout), "butterfly_geo");
mixin externCArray!(const(Gfx), "butterfly_seg3_dl_03005408");
mixin externCArray!(const(Gfx), "butterfly_seg3_dl_030054A0");
mixin externCArray!(const(Animation*), "butterfly_seg3_anims_030056B0");

// coin
mixin externCArray!(const(GeoLayout), "yellow_coin_geo");
mixin externCArray!(const(GeoLayout), "yellow_coin_no_shadow_geo");
mixin externCArray!(const(GeoLayout), "blue_coin_geo");
mixin externCArray!(const(GeoLayout), "blue_coin_no_shadow_geo");
mixin externCArray!(const(GeoLayout), "red_coin_geo");
mixin externCArray!(const(GeoLayout), "red_coin_no_shadow_geo");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007780");
mixin externCArray!(const(Gfx), "coin_seg3_dl_030077D0");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007800");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007828");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007850");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007878");
mixin externCArray!(const(Gfx), "coin_seg3_dl_030078A0");
mixin externCArray!(const(Gfx), "coin_seg3_dl_030078C8");
mixin externCArray!(const(Gfx), "coin_seg3_dl_030078F0");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007918");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007940");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007968");
mixin externCArray!(const(Gfx), "coin_seg3_dl_03007990");
mixin externCArray!(const(Gfx), "coin_seg3_dl_030079B8");

// dirt
mixin externCArray!(const(GeoLayout), "dirt_animation_geo");
mixin externCArray!(const(GeoLayout), "cartoon_star_geo");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302BFF8");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C028");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C238");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C298");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C2B8");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C2D8");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C2F8");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C318");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C378");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C3B0");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C3E8");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C420");
mixin externCArray!(const(Gfx), "dirt_seg3_dl_0302C458");

// door
mixin externCArray!(const(GeoLayout), "castle_door_geo");
mixin externCArray!(const(GeoLayout), "cabin_door_geo");
mixin externCArray!(const(GeoLayout), "wooden_door_geo");
mixin externCArray!(const(GeoLayout), "wooden_door2_geo");
mixin externCArray!(const(GeoLayout), "metal_door_geo");
mixin externCArray!(const(GeoLayout), "hazy_maze_door_geo");
mixin externCArray!(const(GeoLayout), "haunted_door_geo");
mixin externCArray!(const(GeoLayout), "castle_door_0_star_geo");
mixin externCArray!(const(GeoLayout), "castle_door_1_star_geo");
mixin externCArray!(const(GeoLayout), "castle_door_3_stars_geo");
mixin externCArray!(const(GeoLayout), "key_door_geo");
mixin externCArray!(const(Gfx), "door_seg3_dl_03013C10");
mixin externCArray!(const(Gfx), "door_seg3_dl_03013CC8");
mixin externCArray!(const(Gfx), "door_seg3_dl_03013D78");
mixin externCArray!(const(Gfx), "door_seg3_dl_03013E28");
mixin externCArray!(const(Gfx), "door_seg3_dl_03013EA8");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014020");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014100");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014128");
mixin externCArray!(const(Gfx), "door_seg3_dl_030141C0");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014218");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014250");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014280");
mixin externCArray!(const(Gfx), "door_seg3_dl_030142B0");
mixin externCArray!(const(Gfx), "door_seg3_dl_030142E0");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014310");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014340");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014470");
mixin externCArray!(const(Gfx), "door_seg3_dl_030144E0");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014528");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014540");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014888");
mixin externCArray!(const(Gfx), "door_seg3_dl_030149C0");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014A20");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014A50");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014A80");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014B30");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014BE0");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014C90");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014D40");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014EF0");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014F30");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014F68");
mixin externCArray!(const(Gfx), "door_seg3_dl_03014F98");
mixin externCArray!(const(Gfx), "door_seg3_dl_03015008");
mixin externCArray!(const(Gfx), "door_seg3_dl_03015078");
mixin externCArray!(const(Gfx), "door_seg3_dl_030150E8");
mixin externCArray!(const(Gfx), "door_seg3_dl_03015158");
mixin externCArray!(const(Animation*), "door_seg3_anims_030156C0");

// explosion
mixin externCArray!(const(GeoLayout), "explosion_geo");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_03004208");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_03004298");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_030042B0");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_030042C8");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_030042E0");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_030042F8");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_03004310");
mixin externCArray!(const(Gfx), "explosion_seg3_dl_03004328");

// flame
mixin externCArray!(const(GeoLayout), "red_flame_shadow_geo");
mixin externCArray!(const(GeoLayout), "red_flame_geo");
mixin externCArray!(const(GeoLayout), "blue_flame_geo");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B320");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B3B0");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B3C8");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B3E0");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B3F8");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B410");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B428");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B440");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B458");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B470");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B500");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B518");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B530");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B548");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B560");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B578");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B590");
mixin externCArray!(const(Gfx), "flame_seg3_dl_0301B5A8");

// leaves
mixin externCArray!(const(GeoLayout), "leaves_geo");
mixin externCArray!(const(Gfx), "leaves_seg3_dl_0301CDE0");

// mario_cap
mixin externCArray!(const(GeoLayout), "marios_cap_geo");
mixin externCArray!(const(GeoLayout), "marios_metal_cap_geo");
mixin externCArray!(const(GeoLayout), "marios_wing_cap_geo");
mixin externCArray!(const(GeoLayout), "marios_winged_metal_cap_geo");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022B30");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022B68");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022CC8");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022D10");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022E78");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022EA8");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022ED8");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022F20");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022F48");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03022FF8");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_030230B0");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03023108");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03023160");
mixin externCArray!(const(Gfx), "mario_cap_seg3_dl_03023298");

// mist
mixin externCArray!(const(GeoLayout), "mist_geo");
mixin externCArray!(const(GeoLayout), "white_puff_geo");
mixin externCArray!(const(Gfx), "mist_seg3_dl_03000880");
mixin externCArray!(const(Gfx), "mist_seg3_dl_03000920");

// mushroom_1up
mixin externCArray!(const(GeoLayout), "mushroom_1up_geo");
mixin externCArray!(const(Gfx), "mushroom_1up_seg3_dl_0302A628");
mixin externCArray!(const(Gfx), "mushroom_1up_seg3_dl_0302A660");

// number
mixin externCArray!(const(GeoLayout), "number_geo");

// pebble
mixin externCArray!(const(Gfx), "pebble_seg3_dl_0301CB00");

// power_meter
mixin externCArray!(const(ubyte*), "power_meter_health_segments_lut");
mixin externCArray!(const(Gfx), "dl_power_meter_base");
mixin externCArray!(const(Gfx), "dl_power_meter_health_segments_begin");
mixin externCArray!(const(Gfx), "dl_power_meter_health_segments_end");

// sand
mixin externCArray!(const(Gfx), "sand_seg3_dl_0302BCD0");

// star
mixin externCArray!(const(GeoLayout), "star_geo");
mixin externCArray!(const(Gfx), "star_seg3_dl_0302B7B0");
mixin externCArray!(const(Gfx), "star_seg3_dl_0302B870");
mixin externCArray!(const(Gfx), "star_seg3_dl_0302B9C0");
mixin externCArray!(const(Gfx), "star_seg3_dl_0302BA18");

// transparent_star
mixin externCArray!(const(GeoLayout), "transparent_star_geo");
mixin externCArray!(const(Gfx), "transparent_star_seg3_dl_0302C560");
mixin externCArray!(const(Gfx), "transparent_star_seg3_dl_0302C620");

// tree
mixin externCArray!(const(GeoLayout), "bubbly_tree_geo");
mixin externCArray!(const(GeoLayout), "spiky_tree_geo");
mixin externCArray!(const(GeoLayout), "snow_tree_geo");
mixin externCArray!(const(GeoLayout), "spiky_tree1_geo");
mixin externCArray!(const(GeoLayout), "palm_tree_geo");
mixin externCArray!(const(Gfx), "tree_seg3_dl_0302FE88");
mixin externCArray!(const(Gfx), "tree_seg3_dl_0302FEB8");
mixin externCArray!(const(Gfx), "tree_seg3_dl_0302FEE8");
mixin externCArray!(const(Gfx), "tree_seg3_dl_03030FA0");
mixin externCArray!(const(Gfx), "tree_seg3_dl_03032088");
mixin externCArray!(const(Gfx), "tree_seg3_dl_03032170");
mixin externCArray!(const(Gfx), "tree_seg3_dl_03033258");

// warp_collision
mixin externCArray!(const(Collision), "door_seg3_collision_0301CE78");
mixin externCArray!(const(Collision), "lll_hexagonal_mesh_seg3_collision_0301CECC");

// warp_pipe
mixin externCArray!(const(GeoLayout), "warp_pipe_geo");
mixin externCArray!(const(Gfx), "warp_pipe_seg3_dl_03008E40");
mixin externCArray!(const(Gfx), "warp_pipe_seg3_dl_03008F98");
mixin externCArray!(const(Gfx), "warp_pipe_seg3_dl_03009968");
mixin externCArray!(const(Gfx), "warp_pipe_seg3_dl_03009A20");
mixin externCArray!(const(Gfx), "warp_pipe_seg3_dl_03009A50");
mixin externCArray!(const(Collision), "warp_pipe_seg3_collision_03009AC8");

// white_particle
mixin externCArray!(const(GeoLayout), "white_particle_geo");
mixin externCArray!(const(Gfx), "white_particle_dl");

// wooden_signpost
mixin externCArray!(const(GeoLayout), "wooden_signpost_geo");
mixin externCArray!(const(Gfx), "wooden_signpost_seg3_dl_0302D9C8");
mixin externCArray!(const(Gfx), "wooden_signpost_seg3_dl_0302DA48");
mixin externCArray!(const(Gfx), "wooden_signpost_seg3_dl_0302DC40");
mixin externCArray!(const(Gfx), "wooden_signpost_seg3_dl_0302DCD0");
mixin externCArray!(const(Gfx), "wooden_signpost_seg3_dl_0302DD08");
mixin externCArray!(const(Collision), "wooden_signpost_seg3_collision_0302DD80");

