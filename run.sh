#!/bin/bash

# docker run -v $PWD:/root/.config/kibitzr -v $PWD/pages:/pages peterdemin/kibitzr run
docker run -d --rm -v $PWD:/root/.config/kibitzr -v $PWD/pages:/pages 34d68389d6b5 run