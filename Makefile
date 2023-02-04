check:
	lua-format ./**/*.lua --check && \
	selene ./**/*.lua && \
	deno fmt --check && \
	deno check formatter/src/index.ts

fmt:
	lua-format ./**/*.lua -i && \
	deno fmt

test:
	./scripts/run_tests.sh
