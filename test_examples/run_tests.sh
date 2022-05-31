#!/bin/bash
./build_app.sh
cd func_tests/scripts || exit
./tests.sh
