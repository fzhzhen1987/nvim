"一些可能要改的设置
let g:loaded_python_provider = 0

if ($OS == 'Windows_NT')
	let g:python3_host_prog='C:/Scoop/apps/python/current/python.exe'
else
	let g:python3_host_prog='/usr/bin/python3'
endif
