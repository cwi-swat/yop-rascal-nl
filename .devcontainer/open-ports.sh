#!/bin/bash
for port in {9000..12000}; do
  gitpod environment port open $port --name "P${port}" &
done
wait
