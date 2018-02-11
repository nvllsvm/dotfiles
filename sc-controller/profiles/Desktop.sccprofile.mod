{
    "_": "", 
    "buttons": {
        "A": {
            "action": "button(Keys.KEY_ENTER)"
        }, 
        "B": {
            "action": "button(Keys.KEY_ESC)"
        }, 
        "BACK": {
            "action": "button(Keys.KEY_BACKSPACE)"
        }, 
        "C": {
            "action": "hold(menu('Default.menu'), menu('Default.menu'))"
        }, 
        "CPADPRESS": {
            "action": "button(Keys.BTN_LEFT)"
        }, 
        "LB": {
            "action": "button(Keys.KEY_LEFTCTRL)"
        }, 
        "RB": {
            "action": "button(Keys.KEY_LEFTALT)"
        }, 
        "RPAD": {
            "action": "button(Keys.BTN_LEFT)"
        }, 
        "START": {
            "action": "button(Keys.KEY_LEFTSHIFT)"
        }, 
        "X": {
            "action": "button(Keys.KEY_SPACE)"
        }, 
        "Y": {
            "action": "button(Keys.KEY_TAB)"
        }
    }, 
    "cpad": {
        "action": "mouse()"
    }, 
    "gyro": {}, 
    "is_template": false, 
    "menus": {}, 
    "pad_left": {
        "action": "feedback(LEFT, 4096, 16, ball(XY(mouse(Rels.REL_HWHEEL, 1.0), mouse(Rels.REL_WHEEL, 1.0))))"
    }, 
    "pad_right": {
        "action": "smooth(8, 0.78, 2.0, feedback(RIGHT, 256, ball(mouse())))"
    }, 
    "stick": {
        "action": "sens(6.0, 6.0, mouse())"
    }, 
    "trigger_left": {
        "action": "trigger(50, button(Keys.BTN_RIGHT))"
    }, 
    "trigger_right": {
        "action": "trigger(50, button(Keys.BTN_LEFT))"
    }, 
    "version": 1.3
}