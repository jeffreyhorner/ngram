#!/bin/bash
memcached -u nobody -M -m 11264 -v -I 2k -d </dev/null 2>/dev/null 1>/dev/null
