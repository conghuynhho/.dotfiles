# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "$WORKDIR/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "person-skijan-vi"; then

	# Create a new window inline within session layout definition.
	new_window "person-skijan-vi"

	# api skijan
	# gui-skijan
	# guard-skijan

	run_cmd "kp 8920" #guard-skijan
	run_cmd "kp 8925" #api-skijan
	run_cmd "kp 8908" #api-upload

	run_cmd "nvm use 16 && cd $WORKDIR/blog.gogojungle.co.jp/ && yarn start -F=gg.gui.skijan.vi^... -F=gogo.guard.skijan... -F=gogo.api.skijan.vi... -F=gogo.api.upload..."

	if nc -z localhost 3306; then
		echo "Port 3306 is running."
	else
		split_h 40
		run_cmd "asm"
		echo "Port 3306 is not running."
	fi

	if nc -z localhost 8924; then
		echo "Port 8924( GUI_SKIJAN-vi) is running."
		run_cmd "kp 8924"
	fi

	split_v 40
	run_cmd "nvm use 16 && cd $WORKDIR/blog.gogojungle.co.jp/apps/gui/skijan-vi"

	tmux select-layout tiled
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
