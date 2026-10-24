
help:
	@echo $(PWD)
	@echo $(USER)

build:
	docker build --pull -t claude-code .

rebuild:
	docker build --pull --no-cache -t claude-code .

run:
	# -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY
	docker run -it --rm \
		-v /Users/$(USER)/.claude.json:/root/.claude.json \
		-v /Users/$(USER)/.claude:/root/.claude \
		-v $(PWD):$(PWD) \
		-w $(PWD) \
		claude-code

