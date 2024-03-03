require('alchemy').setup({
    api_key = vim.fn.getenv('OPENAI_API_KEY'),  -- Encourage users to use environment variables for sensitive information.
    disableKeyMappings = false,  -- Example of disabling key mappings.
})
