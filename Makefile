IMG ?= frodo
VERSION ?= latest
CONTAINER_TOOL ?= docker

CSV_FILE ?= lupin60-auditLog.csv
JSON_FILE ?= output_log.json

.PHONY: docker-build
docker-build: 
	$(CONTAINER_TOOL) build -t ${IMG} .

.PHONY: docker-push
docker-push: ## Push docker image with the manager.
	$(CONTAINER_TOOL) push ${IMG}

.PHONY: convert-to-json
convert-to-json: 
	python cloud_log_transfer.py --input ${CSV_FILE} --output ${JSON_FILE}

