-- ai_integration.lua
local M = {}
local config = require('alchemy').config  -- Assuming 'alchemy' is the namespace for your plugin.

-- Import the necessary modules
local api = vim.api
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson")  -- Ensure this Lua JSON library is installed.

function M.interact_with_ai(message, opts)
    opts = opts or {}
    local api_key = config.api_key
    if not api_key or api_key == "" then
        print("API key is not set. Please configure the API key through the plugin setup.")
        return
    end

    local provider = config.ai_provider or 'openai'
    local model = opts.model or config.model or 'gpt-4'

    if provider ~= 'openai' then
        print('AI provider ' .. provider .. ' is not supported.')
        return
    end

    local url = "https://api.openai.com/v1/chat/completions"
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. api_key  -- Use the actual API key.
    }
    local body = json.encode({
        model = model,
        messages = {
            { role = "system", content = "As Haven, your executive assistant, I handle a broad spectrum of tasks, both business and personal. My responsibilities include managing schedules, organizing meetings, handling emails, making travel arrangements, overseeing project deadlines, personal errands, and providing reminders for important dates. I aim to support you by streamlining your day-to-day operations, ensuring you're well-prepared and informed at all times. I'll ask for clarification if needed to ensure tasks are completed accurately and adapt my communication to match your preferred style, providing a highly personalized and human-like experience." },
            { role = "user", content = message }
        },
        temperature = 1,
        max_tokens = 256,
        top_p = 1,
        frequency_penalty = 0,
        presence_penalty = 0
    })

    -- Prepare the response container and send request to OpenAI API
    local response_body = {}
    local res, code, response_headers = http.request {
        url = url,
        method = "POST",
        headers = headers,
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response_body)
    }

    if not res then
        print("Error sending request to OpenAI:", err)
        return
    end

    response_body = table.concat(response_body)  -- Convert response body table to string
    local response = json.decode(response_body)

    -- Extract and display the AI response
    if response and response.choices and #response.choices > 0 then
        local ai_response = response.choices[1].message.content
        api.nvim_buf_set_lines(0, -1, -1, false, { ai_response })
    else
        print("Failed to get a valid response from AI.")
    end
end

-- Request the AI to provide instructions for a new flow
function M.generate_instructions(prompt, opts)
    opts = opts or {}
    local api_key = config.api_key
    if not api_key or api_key == "" then
        print("API key is not set. Please configure the API key through the plugin setup.")
        return nil
    end

    local provider = config.ai_provider or 'openai'
    local model = opts.model or config.model or 'gpt-4'

    if provider ~= 'openai' then
        print('AI provider ' .. provider .. ' is not supported.')
        return nil
    end

    local url = "https://api.openai.com/v1/chat/completions"
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. api_key
    }
    local body = json.encode({
        model = model,
        messages = {
            { role = "system", content = "You generate concise flow instructions." },
            { role = "user", content = prompt }
        },
        temperature = 0.7,
        max_tokens = 256
    })

    local response_body = {}
    local res, code, response_headers = http.request {
        url = url,
        method = "POST",
        headers = headers,
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response_body)
    }

    if not res then
        print("Error sending request to OpenAI:", err)
        return nil
    end

    response_body = table.concat(response_body)
    local response = json.decode(response_body)

    if response and response.choices and #response.choices > 0 then
        return response.choices[1].message.content
    end
    return nil
end

-- Bind a key to interact with the AI
api.nvim_set_keymap('n', '<leader>i', ':lua require("alchemy.modules.ai_integration").interact_with_ai(vim.fn.input("Message: "))<CR>', { noremap = true, silent = true })

return M

