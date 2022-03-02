require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.gtd.base"] = {
            config = {
                workspace = "notes",
            }
        },
        ["core.norg.concealer"] = {},
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp",
            }
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/syncthing/default/notes",
                },
                autochdir = true,
                index = "index.norg",
            }
        }
    }
}
