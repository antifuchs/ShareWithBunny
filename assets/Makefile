# This file contains the resolutions we have to resize to; adjust as
# more resolution requirements come out:
JSON_SPEC = svgexport.json

SVGEXPORT = node_modules/.bin/svgexport

INPUT = 1f430.svg
OUTPUT_DIR = output
OUTPUTS = $(shell jq  -r '.[0].output|map(.[0]) | @sh' < ${JSON_SPEC})

all: ${OUTPUTS} ${OUTPUT_DIR}
	${SVGEXPORT} ${JSON_SPEC}

${SVGEXPORT}:
	npm install svgexport

${OUTPUT_DIR}:
	mkdir -p ${OUTPUT_DIR}

${OUTPUTS}: ${INPUT} ${SVGEXPORT}


.PHONY: all
