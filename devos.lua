-- lua/plugins/devos.lua
return {
    {
      "DevOSPlugin",
      path = "C:\\Users\\Racin\\AppData\\Local\\nvim\\lua\\plugins\\devos", -- Adjust the path as necessary
      config = function()
        require("devos").setup()
      end,
    },
  }
  

  -- devos/plugin/devos.lua
if not pcall(require, "devos") then
    print("Failed to load DevOS")
    return
  end
  
  require('devos').setup()
  