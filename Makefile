.PHONY: init
init:
	$(info --- init)
	astro dev init

.PHONY: start
start: 
	astro dev start

.PHONY: restart
restart:
	astro dev restart

.PHONY: ps
ps:
	astro dev ps

.PHONY: bash
bash:
	astro dev bash
.PHONY: help
help:
	astro dev help

.PHONY: pgdump
pgdump:
	pg_dump -h 127.0.0.1 -p 5433 -U appuser b2bdb --file ./init-scripts/populate_b2bdb.sql --insert

.PHONY: b2bdb
b2bdb:
	docker exec -it b2bdb psql -d b2bdb -U appuser