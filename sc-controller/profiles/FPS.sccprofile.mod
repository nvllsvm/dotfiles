{
    "_": "", 
    "buttons": {
        "BACK": {
            "action": "button(Keys.KEY_ENTER)"
        }, 
        "C": {
            "action": "hold(menu('Default.menu'), menu('Default.menu'))"
        }, 
        "LB": {
            "action": "mouse(Rels.REL_WHEEL, -1)"
        }, 
        "RB": {
            "action": "mouse(Rels.REL_WHEEL, 1)"
        }, 
        "START": {
            "action": "button(Keys.KEY_ESC)"
        }
    }, 
    "cpad": {}, 
    "gyro": {}, 
    "is_template": false, 
    "menus": {}, 
    "pad_left": {
        "action": "click(dpad(button(Keys.KEY_UP), button(Keys.KEY_DOWN), button(Keys.KEY_LEFT), button(Keys.KEY_RIGHT)))"
    }, 
    "pad_right": {
        "action": "smooth(8, 0.75, 2, feedback(RIGHT, 277, sens(1.5, 1.5, ball(mouse()))))"
    }, 
    "stick": {
        "action": "XY(axis(Axes.ABS_X), raxis(Axes.ABS_Y))"
    }, 
    "trigger_left": {
        "action": "trigger(254, 255, button(Keys.BTN_RIGHT))"
    }, 
    "trigger_right": {
        "action": "trigger(254, 255, button(Keys.BTN_LEFT))"
    }, 
    "version": 1.3
}