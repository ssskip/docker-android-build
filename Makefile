.IGNORE: default run

build:
	docker build -t reddit/android:java8-r24-4-1 .

run:
	docker run --rm -it reddit/android:java8-r24-4-1 bash

push:
	docker push reddit/android:java8-r24-4-1

default: build
