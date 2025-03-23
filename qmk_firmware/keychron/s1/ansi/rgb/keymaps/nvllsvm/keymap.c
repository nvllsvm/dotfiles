#include QMK_KEYBOARD_H

#define PRODUCT_S1_ANSI_RGB 0x0410

// these use the fork https://github.com/Keychron/qmk_firmware/tree/wireless_playground
#define PRODUCT_K3_MAX_ANSI_RGB 0x0A30
#define PRODUCT_K3_PRO_ANSI_RGB 0x0230

#if PRODUCT_ID==PRODUCT_K3_MAX_ANSI_RGB
    #include "keychron_common.h"
#elif PRODUCT_ID==PRODUCT_S1_ANSI_RGB
    #define BAT_LVL _______
    #define BT_HST1 _______
    #define BT_HST2 _______
    #define BT_HST3 _______
#endif

// clang-format off

enum layers{
    MAC_BASE,
    MAC_FN,
    WIN_BASE,
    WIN_FN
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [MAC_BASE] = LAYOUT_ansi_84(
        KC_ESC,   KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   KC_PSCR,  KC_DEL,   KC_HOME,
        KC_GRV,   KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,            KC_PGUP,
        KC_TAB,   KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,            KC_PGDN,
        KC_ESC,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,            KC_ENT,             KC_END,
        KC_LSFT,            KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,            KC_RSFT,  KC_UP,    KC_PAUS,
        KC_LCTL,  KC_LOPT,  KC_LCMD,                                KC_SPC,                                 MO(MAC_FN),KC_RCMD, KC_RCTL,  KC_LEFT,  KC_DOWN,  KC_RGHT),

    [MAC_FN] = LAYOUT_ansi_84(
        KC_CAPS,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  KC_INS,   RGB_HUI,
        _______,  BT_HST1,  BT_HST2,  BT_HST3,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            RGB_SAI,
        RGB_TOG,  KC_MUTE,  KC_VOLD,  KC_VOLU,  KC_BRMU,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            RGB_VAI,
        _______,  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_BRMD,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,            RGB_SPI,
        _______,            _______,  _______,  _______,  _______,  BAT_LVL,  NK_TOGG,  _______,  _______,  _______,  _______,            _______,  _______,  KC_SCROLL_LOCK,
        _______,  _______,  _______,                                _______,                                _______,  KC_APP,   _______,  _______,  _______,  RGB_MOD),

    [WIN_BASE] = LAYOUT_ansi_84(
        KC_ESC,   KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   KC_PSCR,  KC_DEL,   KC_HOME,
        KC_GRV,   KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,            KC_PGUP,
        KC_TAB,   KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,            KC_PGDN,
        KC_ESC,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,            KC_ENT,             KC_END,
        KC_LSFT,            KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,            KC_RSFT,  KC_UP,    KC_PAUS,
        KC_LCTL,  KC_LGUI,  KC_LALT,                                KC_SPC,                                 MO(WIN_FN), KC_RALT,KC_RCTL,  KC_LEFT,  KC_DOWN,  KC_RGHT),

    [WIN_FN] = LAYOUT_ansi_84(
        KC_CAPS,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  KC_INS,   RGB_HUI,
        _______,  BT_HST1,  BT_HST2,  BT_HST3,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            RGB_SAI,
        RGB_TOG,  KC_MUTE,  KC_VOLD,  KC_VOLU,  KC_BRIU,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            RGB_VAI,
        _______,  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_BRID,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,            RGB_SPI,
        _______,            _______,  _______,  _______,  _______,  BAT_LVL,  NK_TOGG,  _______,  _______,  _______,  _______,            _______,  _______,  KC_SCROLL_LOCK,
        _______,  _______,  _______,                                _______,                                _______,  KC_APP,   _______,  _______,  _______,  RGB_MOD)
};
