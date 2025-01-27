-- This is the entry project local nvim configuration
-- used by plugin "klen/nvim-config-local" to
-- load project specific settings, when nvim is
-- started on this project.

-- Load debug adapters in this project.
-- Needs https://github.com/ldelossa/nvim-dap-projects
nvimdap = require("nvim-dap-projects")
nvimdap.search_project_config()

local group = vim.api.nvim_create_augroup("StripJinja", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.jinja",
    group = group,
    callback = function()
        local fname = vim.fn.expand("%:t") -- Get the filename
        local stripped_name = fname:gsub("%.jinja", "") -- Strip `.jinja`
        local ext = stripped_name:match("%.(%w+)$") -- Extract the new extension
        if ext then
            vim.bo.filetype = ext -- Set the filetype
        end
    end,
})
