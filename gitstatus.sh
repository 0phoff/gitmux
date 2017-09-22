#!/bin/bash
#--------------------------------------------------------------------------------------------------------
# GITSTATUS
#--------------------------------------------------------------------------------------------------------
#
# GITSTATUS SCRIPT: Internal file for GITMUX plugin
# By 0phoff
#
# Original script by:
#   Alan K. Stebbens <aks@stebbens.org> [http://github.com/aks]
# Modified by:
#   Aurelien Rainone [https://github.com/aurelien-rainone]
#
#--------------------------------------------------------------------------------------------------------

dir="$1"
if [ ! -d "$1" ]; then
  exit 1
fi
cd "$dir" > /dev/null

readonly gitstatus=$( LC_ALL=C git status --untracked-files=all --porcelain --branch )

# if the status is fatal, exit now
[[ "$?" -ne 0 ]] && exit 0

num_staged=0
num_changed=0
num_conflicts=0
num_untracked=0
while IFS='' read -r line || [[ -n "$line" ]]; do
  status=${line:0:2}
  case "$status" in
    '##') branch_line="${line/\.\.\./^}" ;;
    ?M) ((num_changed++)) ;;
    U?) ((num_conflicts++)) ;;
    \?\?) ((num_untracked++)) ;;
    *) ((num_staged++)) ;;
  esac
done <<< "$gitstatus"

num_stashed=0
stash_file="$( git rev-parse --git-dir )/logs/refs/stash"
if [[ -e "${stash_file}" ]]; then
  while IFS='' read -r wcline || [[ -n "$wcline" ]]; do
    ((num_stashed++))
  done < "${stash_file}"
fi

clean=0
if (( num_changed == 0 && num_staged == 0 && num_untracked == 0 && num_stashed == 0 && num_conflicts == 0 )) ; then
  clean=1
fi

IFS="^" read -ra branch_fields <<< "${branch_line/\#\# }"
branch="${branch_fields[0]}"
remote=
upstream=

if [[ "$branch" == *"Initial commit on"* ]]; then
  IFS=" " read -ra fields <<< "$branch"
  branch="${fields[3]}"
  remote="_NO_REMOTE_TRACKING_"
elif [[ "$branch" == *"no branch"* ]]; then
  tag=$( git describe --exact-match )
  if [[ -n "$tag" ]]; then
    branch="$tag"
  else
    branch="_PREHASH_$( git rev-parse --short HEAD )"
  fi
else
  if [[ "${#branch_fields[@]}" -eq 1 ]]; then
    remote="_NO_REMOTE_TRACKING_"
  else
    IFS="[,]" read -ra remote_fields <<< "${branch_fields[1]}"
    upstream="${remote_fields[0]}"
    for remote_field in "${remote_fields[@]}"; do
      if [[ "$remote_field" == *ahead* ]]; then
        num_ahead=${remote_field:6}
        ahead="${num_ahead}"
      fi
      if [[ "$remote_field" == *behind* ]]; then
        num_behind=${remote_field:7}
        behind="${num_behind# }"
      fi
    done
  fi
fi

if [[ -z "$ahead" ]] ; then
    ahead=0
fi
if [[ -z "$behind" ]] ; then
    behind=0
fi

if [[ -z "$upstream" ]] ; then
  upstream='^'
fi

printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
  "$branch" \
  "$ahead" \
  "$behind" \
  "$upstream" \
  $num_staged \
  $num_conflicts \
  $num_changed \
  $num_untracked \
  $num_stashed \
  $clean
