.PHONY: test
test:
	cp src/build.sh test/; cd test; ./build.sh

clean:
	rm -rf test/*