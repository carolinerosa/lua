all:
	curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
	tar zxf lua-5.3.5.tar.gz
	cd lua-5.3.5
	lua teste.lua
