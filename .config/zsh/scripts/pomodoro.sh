pomodoro() {
  typeset -A pomo_options

  pomo_options["work"]=${1:-25}
  pomo_options["break"]=${2:-5}
  pomo_options["long_break"]=${3:-15}

  local current_phase="work"
  if [[ "$1" == "break" ]]; then
    current_phase="break"
  fi

  local pomodoro_count=0

  trap - INT

  while true; do
    local duration_key
    local notification_title
    local notification_text
    local notification_speaker

    if [[ "$current_phase" == "work" ]]; then
      pomodoro_count=$((pomodoro_count + 1))
      duration_key="work"
      notification_title="🍅 Session done"
      notification_text="It is now time to take a <b>BREAK</b>!"
      notification_speaker="Break time"
    else
      if (( (pomodoro_count % 4) == 0 && pomodoro_count > 0 )); then
        echo "Taking a LONG BREAK!" | lolcat
        duration_key="long_break"
      else
        duration_key="break"
      fi
      notification_title="🧘 Break over"
      notification_text="Time to get back to <b>WORK</b>"
      notification_speaker="Work time"
    fi

    echo "$current_phase" | lolcat
    timer ${pomo_options["$duration_key"]}m
    local timer_exit_status=$?

    if [[ "$timer_exit_status" -ne 0 ]]; then
      echo "Pomodoro stopped."
      break
    fi

    notify-send -u normal -t 3000 -i alarm "$notification_title" "$notification_text"

    if [[ "$current_phase" == "work" ]]; then
      current_phase="break"
    else
      current_phase="work"
    fi
  done
  exit
}

alias wo="pomodoro"
alias br="pomodoro break"
