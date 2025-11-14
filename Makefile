.PHONY: install test run

install:
	uv tool install .

test:
	python -m dotenv_to_json.cli -i sample.env -p

run:
	python -m dotenv_to_json.cli
