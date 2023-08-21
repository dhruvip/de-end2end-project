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

.PHONY: kill
kill:
	astro dev kill

.PHONY: bash
bash:
	astro dev bash
.PHONY: help
help:
	astro dev help

.PHONY: pgdump
pgdump:
	pg_dump -h 127.0.0.1 -p 5433 -U appuser b2bdb -v SEARCH_PATH=b2bschema --file ./init-scripts/populate_b2bdb_2.sql --insert

.PHONY: b2bdb
b2bdb:
	docker exec -it b2bdb psql -d b2bdb -U appuser

.PHONY: data_dump
data_dump:
	pg_dump -h 127.0.0.1 -p 5433 -U appuser b2bdb --column-inserts --data-only -v SEARCH_PATH=b2bschema --file include/utils/b2bdb_data_dump.sql
	sed -i 's|public.||g' include/utils/b2bdb_data_dump.sql
