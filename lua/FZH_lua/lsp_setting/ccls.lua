require('lspconfig').ccls.setup {
	init_options = {
		index = {
			threads = 0;
		};
		clang = {
			excludeArgs = { "-frounding-math"};
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


