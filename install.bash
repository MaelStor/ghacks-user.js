#!/usr/bin/env bash

this="${BASH_SOURCE[0]}"
this_name=$(basename "${this}")
this_dir=$(dirname "${this}")

profiles_path="${HOME}/.mozilla/firefox"
profiles=$(grep '^Path' "${profiles_path}/profiles.ini" | cut -d"=" -f2 ) 

_error() {
	echo "${this_name}: [E]: $@" >&2
}

_copy() {
	cp -uv "${@:1:$#-1}" "${!#}"
	
}

cd "${this_dir}" || exit 1

if [ -n "${profiles}" ]; then
	declare -a files
	files=( prefsCleaner.sh updater.sh user.js )

	for profile in ${profiles}; do
		profile_path="${profiles_path}/${profile}"
		echo "Copying ${files[@]} to ${profile_path} ..."
		cp -uv ${files[@]} "${profile_path}" ||
			_error "Copy failed"
		set -x 

		echo "Make .sh files executable ..."
		for file in ${files[@]}; do
			echo ${file}
			[[ "${file}" =~ .*\.sh$ ]] && 
				chmod +x "${profile_path}/${file}"
		done
	done
else
	_error "There are no profiles in ${profiles_path}"
	exit 1
fi

