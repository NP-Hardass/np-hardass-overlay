#!/bin/bash

# Based on https://github.com/wine-compholio/wine-staging/blob/master/precommit-hook.sh
# 
# Installation: in the overlay root directory,
#   ln -s ../../scripts/precommit-hook.sh .git/hooks/pre-commit

# For each file modified
git diff --cached --name-status | while read status file; do
	# If an ebuild or a changelog
	if [[ "${file}" =~ .ebuild$ ]] || [[ "${file}" =~ ChangeLog$ ]]; then
		# Reset the header if need be
		sed -i 's/^# \$Header: .\{1,\}\$$/^# \$Header: \$$/' "${file}" && git add "${file}" || exit 1
		break;
	fi
done
