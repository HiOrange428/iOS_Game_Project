// ----------------------------------------
// Sprite definitions for 'character_texture'
// Generated with TexturePacker 5.5.0
//
// https://www.codeandweb.com/texturepacker
// ----------------------------------------

import SpriteKit


class character_texture {

    // sprite names
    let AMELIA_AMELIA_FLY_BACKWARD      = "Amelia/Amelia_fly_backward"
    let AMELIA_AMELIA_FLY_BACKWARD_FIRE = "Amelia/Amelia_fly_backward_fire"
    let AMELIA_AMELIA_FLY_FORWARD       = "Amelia/Amelia_fly_forward"
    let AMELIA_AMELIA_FLY_FORWARD_FIRE  = "Amelia/Amelia_fly_forward_fire"
    let AMELIA_AMELIA_FLY_NORMAL        = "Amelia/Amelia_fly_normal"
    let AMELIA_AMELIA_FLY_NORMAL_FIRE   = "Amelia/Amelia_fly_normal_fire"
    let GURA_GURA_1                     = "Gura/gura_1"
    let GURA_GURA_2                     = "Gura/gura_2"
    let GURA_GURA_3                     = "Gura/gura_3"
    let GURA_GURA_TRIDENT               = "Gura/gura_trident"
    let ENEMY_BAT_BAT_1                 = "enemy/bat/bat_1"
    let ENEMY_BAT_BAT_2                 = "enemy/bat/bat_2"
    let ENEMY_BAT_BAT_3                 = "enemy/bat/bat_3"
    let ENEMY_GHOST_GHOST_1             = "enemy/ghost/ghost_1"
    let ENEMY_GHOST_GHOST_2             = "enemy/ghost/ghost_2"
    let ENEMY_GHOST_GHOST_3             = "enemy/ghost/ghost_3"
    let SKILL_BEAM                      = "skill/beam"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "character_texture")


    // individual texture objects
    func Amelia_Amelia_fly_backward() -> SKTexture      { return textureAtlas.textureNamed(AMELIA_AMELIA_FLY_BACKWARD) }
    func Amelia_Amelia_fly_backward_fire() -> SKTexture { return textureAtlas.textureNamed(AMELIA_AMELIA_FLY_BACKWARD_FIRE) }
    func Amelia_Amelia_fly_forward() -> SKTexture       { return textureAtlas.textureNamed(AMELIA_AMELIA_FLY_FORWARD) }
    func Amelia_Amelia_fly_forward_fire() -> SKTexture  { return textureAtlas.textureNamed(AMELIA_AMELIA_FLY_FORWARD_FIRE) }
    func Amelia_Amelia_fly_normal() -> SKTexture        { return textureAtlas.textureNamed(AMELIA_AMELIA_FLY_NORMAL) }
    func Amelia_Amelia_fly_normal_fire() -> SKTexture   { return textureAtlas.textureNamed(AMELIA_AMELIA_FLY_NORMAL_FIRE) }
    func Gura_gura_1() -> SKTexture                     { return textureAtlas.textureNamed(GURA_GURA_1) }
    func Gura_gura_2() -> SKTexture                     { return textureAtlas.textureNamed(GURA_GURA_2) }
    func Gura_gura_3() -> SKTexture                     { return textureAtlas.textureNamed(GURA_GURA_3) }
    func Gura_gura_trident() -> SKTexture               { return textureAtlas.textureNamed(GURA_GURA_TRIDENT) }
    func enemy_bat_bat_1() -> SKTexture                 { return textureAtlas.textureNamed(ENEMY_BAT_BAT_1) }
    func enemy_bat_bat_2() -> SKTexture                 { return textureAtlas.textureNamed(ENEMY_BAT_BAT_2) }
    func enemy_bat_bat_3() -> SKTexture                 { return textureAtlas.textureNamed(ENEMY_BAT_BAT_3) }
    func enemy_ghost_ghost_1() -> SKTexture             { return textureAtlas.textureNamed(ENEMY_GHOST_GHOST_1) }
    func enemy_ghost_ghost_2() -> SKTexture             { return textureAtlas.textureNamed(ENEMY_GHOST_GHOST_2) }
    func enemy_ghost_ghost_3() -> SKTexture             { return textureAtlas.textureNamed(ENEMY_GHOST_GHOST_3) }
    func skill_beam() -> SKTexture                      { return textureAtlas.textureNamed(SKILL_BEAM) }


    // texture arrays for animations
    func Gura_gura_() -> [SKTexture] {
        return [
            Gura_gura_1(),
            Gura_gura_2(),
			Gura_gura_1(),
            Gura_gura_3()
        ]
    }

    func enemy_bat_bat_() -> [SKTexture] {
        return [
            enemy_bat_bat_1(),
            enemy_bat_bat_2(),
            enemy_bat_bat_3()
        ]
    }

    func enemy_ghost_ghost_() -> [SKTexture] {
        return [
            enemy_ghost_ghost_1(),
            enemy_ghost_ghost_2(),
            enemy_ghost_ghost_3()
        ]
    }


}
