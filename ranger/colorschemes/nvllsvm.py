from ranger.gui import color
import ranger.colorschemes.default


class Nvllsvm(ranger.colorschemes.default.Default):

    def use(self, context):
        fg, bg, attr = super().use(context)
        if context.tab:
            if context.good:
                bg = color.white
                fg = color.black
        return fg, bg, attr
