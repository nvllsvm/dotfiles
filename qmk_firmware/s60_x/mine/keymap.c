#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    LAYOUT_kc(
         GRV,    1,    2,   3,   4,   5,   6,   7,   8,    9,    0, MINS,  EQL, BSPC,  DEL, \
         TAB,    Q,    W,   E,   R,   T,   Y,   U,   I,    O,    P, LBRC, RBRC, BSLS,       \
         ESC,    A,    S,   D,   F,   G,   H,   J,   K,    L, SCLN, QUOT,   NO,  ENT,       \
        LSFT,   NO,    Z,   X,   C,   V,   B,   N,   M, COMM,  DOT, SLSH,   NO,   UP, RSFT, \
        LCTL, LGUI, LALT,                SPC,                  FN1, LEFT, DOWN, RGHT),

    LAYOUT_kc(
        CAPS,   F1,   F2,   F3,   F4,   F5,   F6,   F7,   F8,   F9,  F10,  F11,  F12, TRNS,  INS, \
        TRNS, MUTE, VOLD, VOLU, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS,       \
        TRNS, MPRV, MPLY, MNXT, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS,       \
        TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, PGUP, TRNS, \
        TRNS, TRNS, TRNS,                   TRNS,                   TRNS, HOME, PGDN, END)
};

const uint16_t PROGMEM fn_actions[] = {
    [0] = ACTION_DEFAULT_LAYER_SET(0),
    [1] = ACTION_LAYER_MOMENTARY(1),
};
