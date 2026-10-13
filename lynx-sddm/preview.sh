#!/bin/bash

sddm-greeter-qt6 --test-mode --theme . 2>&1 & sleep 5 && kill $!
