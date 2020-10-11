#!/usr/bin/env bash

# ================================================= #
#                                                   #
# Thanks to https://github.com/gammazero/workerpool #
#                                                   #
# ================================================= #

set -e
echo "" > coverage.out

for d in $(go list ./... | grep -v vendor); do
    # specific race condition needs to be thoroughly tested to show its ugly face (hence -count=100000)
    go test -run ^TestStopRace$ -count=100000 $d 
    # basic, defaut test cmd
    go test -race -coverprofile=profile.out -covermode=atomic $d

    if [ -f profile.out ]; then
        cat profile.out >> coverage.out
        rm profile.out
    fi
done