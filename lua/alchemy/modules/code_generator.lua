local M = {}
local config = require('alchemy').config
local log = require('alchemy.log')

function M.generate(prompt)
  log.debug("Generating code for prompt:", prompt)
  local api_key = config.api_key or vim.fn.getenv("OPENAI_API_KEY")

  if not api_key or api_key == "" then
    log.debug("OpenAI API Key is not set.")
    return
  end

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

  -- Check for curl command success
  local success = vim.v.shell_error == 0

  if success and response then
    local decoded_response = vim.json.decode(response)
    if decoded_response.choices and #decoded_response.choices > 0 then
      local generated_text = decoded_response.choices[1].text
      log.debug("Generated code: ", generated_text)
    else
      log.debug("Failed to parse generated code from response.")
    end
  else
    log.debug("Failed to generate code")
  end
end

return M
