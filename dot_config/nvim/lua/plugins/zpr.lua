return {
  {
    "shankur/zpr.nvim",
    lazy = false, -- load at startup so socket is always published
    build = function()
      local src = vim.fn.stdpath("data") .. "/lazy/zpr.nvim"
      local bin = vim.fn.expand("~/.local/bin")
      vim.fn.mkdir(bin, "p")
      for _, script in ipairs({ "zpr-call", "zpr-parse-diff", "zpr-push-review" }) do
        vim.fn.system("ln -sf " .. src .. "/bin/" .. script .. " " .. bin .. "/" .. script)
      end
      local skills = vim.fn.expand("~") .. "/claude-kb/skills"
      vim.fn.system("ln -sf " .. src .. "/skills/zpr-review " .. skills .. "/zpr-review")
      local path = vim.fn.getenv("PATH")
      if not path:find(bin, 1, true) then
        vim.notify("zpr.nvim: add " .. bin .. " to your PATH", vim.log.levels.WARN)
      end
    end,
    config = function()
      require("zpr").setup()
    end,
  },
}
