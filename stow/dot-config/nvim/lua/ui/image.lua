return {
	enabled = true,
	doc = {
		inline = false,
		float = true,
		max_width = 80,
		max_height = 40,
	},
	cache = vim.fn.stdpath("cache") .. "/snacks/images",
	convert = {
		notify = true, -- show a notification on error
		magick = {
			default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
			vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
			math = { "-density", 192, "{src}[0]", "-trim" },
			pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
		},
	},
	math = {
		enabled = true, -- enable math expression rendering
		-- in the templates below, `${header}` comes from any section in your document,
		-- between a start/end header comment. Comment syntax is language-specific.
		-- * start comment: `// snacks: header start`
		-- * end comment:   `// snacks: header end`
		typst = {
			tpl = [[
                            #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
                            #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
                            #set text(size: 12pt, fill: rgb("${color}"))
                            ${header}
                            ${content}]],
		},
	},
}
