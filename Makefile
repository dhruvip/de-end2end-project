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