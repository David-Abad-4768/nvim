local js_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-jdtls",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        local dap_virtual_text = require("nvim-dap-virtual-text")

        dapui.setup({
            controls = {
                enabled = true,
                element = "repl",
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "↻",
                    terminate = "□",
                },
            },
            element_mappings = {},
            expand_lines = true,
            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            force_buffers = true,
            icons = {
                collapsed = "",
                current_frame = "",
                expanded = "",
            },
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        { id = "breakpoints", size = 0.25 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 0.25 },
                    },
                    size = 40,
                    position = "left",
                },
                {
                    elements = {
                        { id = "repl", size = 0.5 },
                        { id = "console", size = 0.5 },
                    },
                    size = 10,
                    position = "bottom",
                },
            },
            mappings = {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t",
            },
            render = {
                max_type_length = nil,
            },
        })

        dap_virtual_text.setup()

        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" },
        }

        dap.configurations.c = {
            {
                name = "Launch",
                type = "gdb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
        }

        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "127.0.0.1",
            port = 8123,
            executable = {
                command = "js-debug-adapter",
            },
        }

        for _, language in pairs(js_languages) do
            dap.configurations[language] = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    runtimeExecutable = "node",
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                    sourceMaps = true,
                },
                {
                    type = "pwa-chrome",
                    request = "launch",
                    name = "Launch & Debug Chrome",
                    url = function()
                        local url = coroutine.yield(vim.ui.input({ prompt = "Enter URL", default = "http://localhost:3000" }))
                        return url or "http://localhost:3000"
                    end,
                    webRoot = "${workspaceFolder}",
                    skipFiles = { "<node_internals>/**/*.js" },
                    protocol = "inspector",
                    sourceMaps = true,
                    userDataDir = false,
                },
                {
                    name = "========== Launch .json configs ==========",
                    type = "",
                    request = "launch",
                },
            }
        end

        dap.adapters.java = function(callback)
            callback({
                type = "server",
                host = "127.0.0.1",
                port = 5005,
            })
        end

        dap.configurations.java = {
            {
                type = "java",
                request = "launch",
                name = "Launch Java Program",
                mainClass = function()
                    local handle = io.popen("mvn help:evaluate -Dexpression=mainClass -q -DforceStdout")
                    if not handle then
                        vim.notify("Error: Unable to execute Maven command to get mainClass.", vim.log.levels.ERROR)
                        return ""
                    end

                    local mainClass = handle:read("*a")
                    handle:close()

                    if not mainClass or mainClass == "" then
                        vim.notify("Error: mainClass not found in pom.xml.", vim.log.levels.ERROR)
                        return ""
                    end

                    return mainClass:gsub("%s+", "")
                end,
                projectName = function()
                    local handle = io.popen("mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout")
                    if not handle then
                        vim.notify("Error: Unable to execute Maven command to get projectName.", vim.log.levels.ERROR)
                        return ""
                    end

                    local projectName = handle:read("*a")
                    handle:close()

                    if not projectName or projectName == "" then
                        vim.notify("Error: projectName not found in pom.xml.", vim.log.levels.ERROR)
                        return ""
                    end

                    return projectName:gsub("%s+", "")
                end,
                javaExec = function()
                    local handle = io.popen("which java")
                    if not handle then
                        vim.notify("Error: Unable to find Java executable.", vim.log.levels.ERROR)
                        return ""
                    end

                    local javaExec = handle:read("*a")
                    handle:close()

                    if not javaExec or javaExec == "" then
                        vim.notify("Error: Java executable not found.", vim.log.levels.ERROR)
                        return ""
                    end

                    return javaExec:gsub("%s+", "")
                end,
                classPaths = {}, 
                modulePaths = {},
            },
            {
                type = "java",
                request = "attach",
                name = "Debug (Attach) - Remote",
                hostName = "127.0.0.1",
                port = 5005,
            },
        }

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.api.nvim_set_keymap(
            "n",
            "<F5>",
            ":lua require'dapui'.open(); require'dap'.continue()<CR>",
            { noremap = true, silent = true }
        )

        vim.api.nvim_set_keymap(
            "n",
            "<leader>db",
            ":lua require'dap'.toggle_breakpoint()<CR>",
            { noremap = true, silent = true }
        )
    end,
}

