#!/bin/bash -e

# Copyright 2017 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Extracts .java files from source jars in a specified directory and writes out a list of the files

if [ -z "$1" -o -z "$2" ]; then
  echo "usage: $0 <output dir> <output file> [<jar> ...]" >&2
  exit 1
fi

output_dir=$1
shift
output_file=$1
shift

rm -f $output_file
touch $output_file

for j in "$@"; do
  for f in $(zipinfo -1 $j '*.java'); do
    echo $output_dir/$f >> $output_file
  done
  unzip -qn -d $output_dir $j '*.java'
done

duplicates=$(cat $output_file | sort | uniq -d | uniq)
if [ -n "$duplicates" ]; then
  echo Duplicate source files:
  echo $duplicates
  exit 1
fi