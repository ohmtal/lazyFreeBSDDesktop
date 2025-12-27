#!/bin/sh
echo "Running pkg clean =>  this remove the downloaded package files (cache)."
sudo pkg clean
echo "Running pkg autoremove => this remove packages which no longer required by other packages (handle with care!)"
sudo pkg autoremove
