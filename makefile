
all: run beaut

.PHONY: all run beaut

run:
	processing-java --sketch=D:/LinuxEnv/Cygwin/home/corvus/graph_tool/ --run

beaut: output/curves.json
	cd output; python3 limit_dec.py
