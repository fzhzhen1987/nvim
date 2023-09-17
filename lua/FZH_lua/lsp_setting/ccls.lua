local home = os.getenv("HOME") or ""
local cache_dir = home .. "/.cache/tags/ccls"

require('lspconfig').ccls.setup {
	init_options = {
		index = {
			threads = 0;
		};
		clang = {
			excludeArgs = { "-frounding-math"};
		};
		cache = {
			directory = cache_dir;
		};
		completion = {
			placeholder = false;
			filterAndSort = false;
			detailedLable = true;
		};
		highlight = {
			lsRanges = true;
		};
	};
	on_attach = Itkey_on_attach;
	capabilities = Itkey_capabilities;
	flags = {
		debounce_text_changes = 150;
	};
}


