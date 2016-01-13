.PHONY: test
test:
	cp src/build.sh test/; cp src/spawn.tar.gz test/; cd test; ./build.sh

clean:
	rm -rf test/*