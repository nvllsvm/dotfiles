RGB_MATRIX_EFFECT(solid_reduced_dim)
RGB_MATRIX_EFFECT(solid_reduced_off)

#ifdef RGB_MATRIX_CUSTOM_EFFECT_IMPLS

bool solid_reduced_enabled[] = {
    // row 0
    false, // ESC_INDEX 0
    false, // F1_INDEX 1
    false, // F2_INDEX 2
    false, // F3_INDEX 3
    false, // F4_INDEX 4
    false, // F5_INDEX 5
    false, // F6_INDEX 6
    false, // F7_INDEX 7
    false, // F8_INDEX 8
    false, // F9_INDEX 9
    false, // F10_INDEX 10
    false, // F11_INDEX 11
    false, // F12_INDEX 12
    false, // PRINT_SCREEN_INDEX 13
    false, // DEL_INDEX 14
    false, // HOME_INDEX 15

    // row 1
    false, // TILDE_INDEX 16
    true, // NUM_1_INDEX 17
    true, // NUM_2_INDEX 18
    true, // NUM_3_INDEX 19
    true, // NUM_4_INDEX 20
    true, // NUM_5_INDEX 21
    true, // NUM_6_INDEX 22
    true, // NUM_7_INDEX 23
    true, // NUM_8_INDEX 24
    true, // NUM_9_INDEX 25
    true, // NUM_0_INDEX 26
    true, // MINUS_INDEX 27
    true, // EQUALS_INDEX 28
    false, // BACKSPACE_INDEX 29
    false, // PAGEUP_INDEX 30

    // row 2
    false, // TAB_INDEX 31
    true, // Q_INDEX 32
    true, // W_INDEX 33
    true, // E_INDEX 34
    true, // R_INDEX 35
    true, // T_INDEX 36
    true, // Y_INDEX 37
    true, // U_INDEX 38
    true, // I_INDEX 39
    true, // O_INDEX 40
    true, // P_INDEX 41
    true, // LBRACKET_INDEX 42
    true, // RBRACKET_INDEX 43
    false, // BACKSLASH_INDEX 44
    false, // PAGEDOWN_INDEX 45

    // row 3
    false, // CAPSLOCK_INDEX 46
    true, // A_INDEX 47
    true, // S_INDEX 48
    true, // D_INDEX 49
    true, // F_INDEX 50
    true, // G_INDEX 51
    true, // H_INDEX 52
    true, // J_INDEX 53
    true, // K_INDEX 54
    true, // L_INDEX 55
    true, // SEMICOLON_INDEX 56
    true, // QUOTE_INDEX 57
    false, // ENTER_INDEX 58
    false, // END_INDEX 59

    // row 4
    false, // LSHIFT_INDEX 60
    true, // Z_INDEX 61
    true, // X_INDEX 62
    true, // C_INDEX 63
    true, // V_INDEX 64
    true, // B_INDEX 65
    true, // N_INDEX 66
    true, // M_INDEX 67
    true, // COMMA_INDEX 68
    true, // PERIOD_INDEX 69
    true, // SLASH_INDEX 70
    false, // RSHIFT_INDEX 71
    false, // UP_INDEX 72
    false, // PAUSE_INDEX 73

    // row 5
    false, // LCONTROL_INDEX 74
    false, // WIN_INDEX 75
    false, // LALT_INDEX 76
    false, // SPACE_INDEX 77
    false, // FN_INDEX 78
    false, // RALT_INDEX 79
    false, // RCONTROL_INDEX 80
    false, // LEFT_INDEX 81
    false, // DOWN_INDEX 82
    false, // RIGHT_INDEX 83
};


bool solid_reduced_dim(effect_params_t* params) {
    RGB_MATRIX_USE_LIMITS(led_min, led_max);
    RGB rgb = rgb_matrix_hsv_to_rgb(rgb_matrix_config.hsv);
    uint8_t r = rgb.r;
    uint8_t g = rgb.g;
    uint8_t b = rgb.b;
    uint8_t v = rgb_matrix_config.hsv.v;
    rgb_matrix_config.hsv.v = v / 3;
    rgb = rgb_matrix_hsv_to_rgb(rgb_matrix_config.hsv);
    uint8_t r_dim = rgb.r;
    uint8_t g_dim = rgb.g;
    uint8_t b_dim = rgb.b;
    rgb_matrix_config.hsv.v = v;
    for (uint8_t i = led_min; i < led_max; i++) {
        RGB_MATRIX_TEST_LED_FLAGS();
        if (solid_reduced_enabled[i]) {
            rgb_matrix_set_color(i, r, g, b);
        } else {
            rgb_matrix_set_color(i, r_dim, g_dim, b_dim);
        }
    }
    return rgb_matrix_check_finished_leds(led_max);
}

bool solid_reduced_off(effect_params_t* params) {
    RGB_MATRIX_USE_LIMITS(led_min, led_max);
    RGB rgb = rgb_matrix_hsv_to_rgb(rgb_matrix_config.hsv);
    for (uint8_t i = led_min; i < led_max; i++) {
        RGB_MATRIX_TEST_LED_FLAGS();
        if (solid_reduced_enabled[i]) {
            rgb_matrix_set_color(i, rgb.r, rgb.g, rgb.b);
        } else {
            rgb_matrix_set_color(i, 0, 0, 0);
        }
    }
    return rgb_matrix_check_finished_leds(led_max);
}

#endif // RGB_MATRIX_CUSTOM_EFFECT_IMPLS
