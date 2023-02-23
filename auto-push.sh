#!/bin/bash -e

echo "======== auto push start ========"

git add .

msg='day: '$(date +%y/%m/%d)

git commit -m "$msg"

git push -u origin master

echo "======== auto push success ========"