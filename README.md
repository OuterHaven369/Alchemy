# Alchemy: Enhancing Neovim with AI

Alchemy is a Neovim plugin designed to supercharge your development workflow by integrating advanced AI capabilities directly into your editor. Inspired by the transformative power of alchemy, this tool aims to turn your coding experience into gold, making it more efficient, intuitive, and enjoyable.

## Features

- **AI Code Generation**: Generate code snippets on the fly based on brief descriptions of what you need.
- **Intelligent Code Completion**: Enhance your coding efficiency with AI-powered code completions.
- **Automated Refactoring**: Refactor your code with AI suggestions for improved readability and performance.
- **Dynamic Documentation**: Generate documentation automatically for your codebase using AI insights.
- **Test Assistance**: Get help writing tests for your code to ensure robustness and reliability.
- **Configurable AI Models**: Choose the AI provider and model used for each flow.
- **Automated Hierarchical Flows**: Chain flows together and schedule them to run in the background.

## Installation

### Using LazyVim

If you're using [LazyVim](https://github.com/LazyVim/LazyVim), add the following to your `lua/plugins/alchemy.lua`:

```lua
return {
    {
        "OuterHaven369/Alchemy",
        requires = { -- list any dependencies here },
        config = function()
            require("alchemy").setup()
        end,
    },
}
```

Then, run `:LazyVimSync` or restart Neovim to sync and setup Alchemy.

### Manual Installation

For manual installation, clone this repository and source the plugin in your Neovim configuration:

```sh
git clone https://github.com/OuterHaven369/Alchemy.git ~/.config/nvim/plugins/Alchemy
```

Then, add the following to your `init.lua` or equivalent Neovim configuration file:

```lua
require('alchemy').setup({
    api_key = 'YOUR_OPENAI_API_KEY'
    -- enable verbose logging
    -- debug = true
})
```

Enable `debug` to see detailed log messages during development.

Alchemy will use this key when contacting the OpenAI API. If you omit
`api_key`, the plugin falls back to the `OPENAI_API_KEY` environment variable.

## Usage

Once installed, Alchemy can be configured to your liking. Visit the [documentation](https://github.com/OuterHaven369/Alchemy/wiki) for detailed instructions on configuring and using Alchemy to its full potential.

### Customizing AI Providers and Flows

Alchemy now lets you specify which AI provider and model should power a particular flow. Pass `ai_provider` and `model` when calling `setup` or when creating flows with the flow manager.

```lua
require('alchemy').setup({
    ai_provider = 'openai',
    model = 'gpt-4'
})

-- example of creating a custom flow
local flow_manager = require('alchemy.modules.flow_manager')
flow_manager.create_flow('my-flow', {
    instructions = 'Describe the steps here',
    model = 'gpt-4'
})
```

### Automated and Hierarchical Flows

You can chain flows together and schedule them to run in the background. Use `add_subflow` to create a hierarchy and `schedule_flow` to execute flows on a timer.

```lua
-- create flows
flow_manager.create_flow('parent')
flow_manager.create_flow('child')

-- set up hierarchy
flow_manager.add_subflow('parent', 'child')

-- run every hour
flow_manager.schedule_flow('parent', 3600)

-- generate a flow from the AI
flow_manager.create_flow_from_ai('ai-generated', 'Create a video loop and upload it')
```

# License Overview

This project is generously offered under a dual-license model, designed to accommodate both open-source community projects and commercial initiatives. Our goal is to foster innovation and collaboration while also supporting the project's sustainable development.

## Open Source License

For individuals, educational institutions, and non-profit organizations, this project is freely available under the [OPEN SOURCE LICENSE](LINK_TO_OPEN_SOURCE_LICENSE). This license encourages open collaboration, modification, and sharing, aligning with the core values of the open-source community. For detailed terms and conditions, please refer to the LICENSE file included in this repository.

## Commercial License

For businesses and commercial entities seeking to integrate this project into their operations or products, a commercial license is required. This arrangement is designed to provide the flexibility and support necessary for commercial use, ensuring that your business needs are met while contributing to the ongoing development and improvement of the project. For inquiries about obtaining a commercial license, including pricing and terms, please contact us directly at [CONTACT INFORMATION](mailto:YOUR_EMAIL).

We are committed to ensuring that this project remains accessible and beneficial to a wide range of users, from individual hobbyists to large enterprises. By adopting this dual-license approach, we aim to balance the need for open, collaborative development with the financial sustainability and growth of the project.
