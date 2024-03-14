#!/bin/bash

yamllint -c .yamllint ./**/*.yaml ./**/*.yml

yamllint --fix -c .yamllint ./**/*.yaml ./**/*.yml