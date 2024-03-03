-- ai_integration.lua
local M = {}
local config = require('alchemy').config

-- Import the necessary modules
local api = vim.api
local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson")  -- Ensure you are using a Lua JSON library that you have installed.

-- Function to interact with the OpenAI chatbot
function M.interact_with_ai(message)
    local api_key = vim.fn.getenv("OPENAI_API_KEY")  -- Use an environment variable for the API key.
    if not api_key then
        print("OpenAI API key is not set. Please set the OPENAI_API_KEY environment variable.")
        return
    end

    local url = "https://api.openai.com/v1/chat/completions"
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer YOUR_API_KEY" -- Replace 'YOUR_API_KEY' with your OpenAI API key
    }
    local body = json.encode({
        model = "gpt-4",
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

    -- Send request to OpenAI API
    local res, err = http.request {
        url = url,
        method = "POST",
        headers = headers,
        source = ltn12.source.string(body)
    }

    if not res then
        print("Error:", err)
        return
    end

    -- Decode JSON response
    local response = json.decode(res)

    -- Get AI response
    local ai_response = response.choices[1].message.content

    -- Append AI response to chat window
    api.nvim_buf_set_lines(0, -1, -1, false, { ai_response })
end

-- Bind a key to interact with the AI
api.nvim_set_keymap('n', '<leader>i', ':lua interact_with_ai(vim.fn.input("Message: "))<CR>', { noremap = true, silent = true })

-- Export the function to be used in the configuration
return {
    interact_with_ai = interact_with_ai
}
