local M = {}

function M.generate(prompt)
  -- Your OpenAI API Key
  local api_key = "your_openai_api_key"

  local data = string.format([[
    {
      "prompt": %q,
      "temperature": 0.7,
      "max_tokens": 100,
      "top_p": 1.0,
      "frequency_penalty": 0,
      "presence_penalty": 0
    }
  ]], prompt)

  local curl_cmd = string.format([[curl -s -X POST https://api.openai.com/v1/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer %s" \
    -d '%s']], api_key, data)

  local response = vim.fn.system(curl_cmd)

  if response then
    local first_line = response:match("^.+")
    print("Generated code: ", first_line)
  else
    print("Failed to generate code")
  end
end

return M
