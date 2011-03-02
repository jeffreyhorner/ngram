#!/bin/bash
for i in `ps  ax | grep memcached | grep -v grep | awk '{print $1}'`; do
    kill -9 $i
done
