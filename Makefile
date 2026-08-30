.PHONY: test lint fmt fmt-fix docs clean

test:
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}"

lint:
	luacheck lua plugin tests

fmt:
	stylua --check .

fmt-fix:
	stylua .

docs:
	nvim --headless -c "helptags doc" -c "quit"

clean:
	rm -rf deps doc/tags
