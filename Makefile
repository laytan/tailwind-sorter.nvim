check:
	lua-format ./**/*.lua --check && \
	selene ./**/*.lua && \
	cd formatter && npm run check

fmt:
	lua-format ./**/*.lua -i

test:
	./scripts/run_tests.sh
