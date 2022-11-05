## Lazymark

PersistedMark across files and projects.

My brain is not capable to rememble many marks, I just want one(or 2, but no more than 3. if there's more, I need UI to help).

And I always accidentlly overwrited my mark when I accutally want to jump to it.

And I don't want to use capital letter to mark across projects.

And I want to find my mark after reboot my computer.

So This plugin is born.

## Install

using your favorate plugin manager, for example packer

```lua
use {
	"LintaoAmons/lazymark.nvim",
	-- tag = "v0.1.0" -- use tag for stability, or without this to have latest fixed and functions
}
```

I will continue add some changes to main branch, so if you meet some issue due to new changes, you can just downgrade to your former version.

## Commands | Keymappings | Functions

### Lazymark

```lua
vim.keymap.set("n", "ma", function() require("lazymark").mark() end)
```

### LazymarkGoToMark

```lua
vim.keymap.set("n", "ma", function() require("lazymark").gotoMark() end)
```

### LazymarkCheckCurrentMark

```lua
:lua require("lazymark").check()
```

## Need help

I'm a nvim and lua newbie, please help me with:

- [ ] Why can't find my commands, after installed the plugin?

