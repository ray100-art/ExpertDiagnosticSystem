% =========================================
% COMPUTER TROUBLESHOOTING SYSTEM
% SWI-Prolog — True Decision Tree
% Each question is asked exactly once.
% =========================================

:- dynamic answer/2.
:- dynamic trace_log/1.

% =========================================
% ENTRY POINT
% =========================================

start :-
    reset,
    nl,
    write('========================================'), nl,
    write('   Computer Troubleshooting Assistant   '), nl,
    write('========================================'), nl,
    write('Answer each question with: yes. or no.'), nl,
    write('Type help. at any prompt for guidance.'), nl,
    nl,
    tree_power.

% =========================================
% DECISION TREE
% Each predicate asks ONE question and
% branches into two sub-trees — no question
% is ever repeated across any path.
% =========================================

% LEVEL 1 — Power
tree_power :-
    ask(power_on, 'Is the computer turning on at all'),
    branch_power.

branch_power :- answer(power_on, no),  !, conclude(no_power).
branch_power :- answer(power_on, yes), !, tree_screen.

% LEVEL 2 — Screen
tree_screen :-
    ask(screen_on, 'Is anything visible on the screen'),
    branch_screen.

branch_screen :- answer(screen_on, no),  !, tree_fan.
branch_screen :- answer(screen_on, yes), !, tree_os.

% LEVEL 2b — Fan (blank screen path)
tree_fan :-
    ask(fan_running, 'Can you hear the fan or hard drive running'),
    branch_fan.

branch_fan :- answer(fan_running, yes), !, conclude(blank_screen).
branch_fan :- answer(fan_running, no),  !, conclude(no_power).

% LEVEL 3 — OS loads
tree_os :-
    ask(reaches_os, 'Does the computer fully load to the desktop'),
    branch_os.

branch_os :- answer(reaches_os, no),  !, conclude(boot_failure).
branch_os :- answer(reaches_os, yes), !, tree_peripherals.

% LEVEL 4 — Peripherals
tree_peripherals :-
    ask(keyboard_mouse, 'Are the keyboard and mouse working correctly'),
    branch_peripherals.

branch_peripherals :- answer(keyboard_mouse, no),  !, conclude(peripheral_issue).
branch_peripherals :- answer(keyboard_mouse, yes), !, tree_audio.

% LEVEL 5 — Audio
tree_audio :-
    ask(audio_works, 'Is the audio or sound working'),
    branch_audio.

branch_audio :- answer(audio_works, no),  !, conclude(audio_issue).
branch_audio :- answer(audio_works, yes), !, tree_internet.

% LEVEL 6 — Internet
tree_internet :-
    ask(internet, 'Do you have an internet connection'),
    branch_internet.

branch_internet :- answer(internet, no),  !, tree_wifi.
branch_internet :- answer(internet, yes), !, tree_speed.

% LEVEL 6b — Wi-Fi or wired
tree_wifi :-
    ask(wifi_used, 'Are you connecting via Wi-Fi (not a cable)'),
    branch_wifi.

branch_wifi :- answer(wifi_used, yes), !, conclude(no_internet).
branch_wifi :- answer(wifi_used, no),  !, conclude(wired_issue).

% LEVEL 7 — Speed
tree_speed :-
    ask(running_slow, 'Is the computer running unusually slowly'),
    branch_speed.

branch_speed :- answer(running_slow, no),  !, conclude(all_ok).
branch_speed :- answer(running_slow, yes), !, tree_popups.

% LEVEL 8 — Pop-ups
tree_popups :-
    ask(popups, 'Are there unusual pop-ups or error messages'),
    branch_popups.

branch_popups :- answer(popups, yes), !, conclude(malware_suspected).
branch_popups :- answer(popups, no),  !, tree_heat.

% LEVEL 9 — Heat
tree_heat :-
    ask(hot, 'Does the computer feel hot or shut down randomly'),
    branch_heat.

branch_heat :- answer(hot, yes), !, conclude(overheating).
branch_heat :- answer(hot, no),  !, tree_noise.

% LEVEL 10 — Disk noise
tree_noise :-
    ask(disk_noise, 'Do you hear clicking or grinding noises'),
    branch_noise.

branch_noise :- answer(disk_noise, yes), !, conclude(disk_failure).
branch_noise :- answer(disk_noise, no),  !, conclude(slow_computer).

% =========================================
% CONCLUSION — print result + fixes + trace
% =========================================

conclude(all_ok) :-
    nl,
    write('=================================================='), nl,
    write('DIAGNOSIS: No problem detected.'), nl,
    write('Your computer appears to be working normally.'), nl,
    write('=================================================='), nl,
    nl,
    print_trace.

conclude(Problem) :-
    nl,
    write('=================================================='), nl,
    write('DIAGNOSIS: '), write_problem(Problem), nl,
    write('=================================================='), nl,
    nl,
    suggest_fix(Problem),
    nl,
    print_trace.

% =========================================
% PROBLEM LABELS
% =========================================

write_problem(no_power)          :- write('Computer has no power').
write_problem(blank_screen)      :- write('Blank or black screen').
write_problem(boot_failure)      :- write('Computer fails to boot / OS error').
write_problem(peripheral_issue)  :- write('Keyboard or mouse not working').
write_problem(audio_issue)       :- write('No sound / audio problem').
write_problem(no_internet)       :- write('No internet connection (Wi-Fi)').
write_problem(wired_issue)       :- write('No internet connection (Wired)').
write_problem(malware_suspected) :- write('Possible malware or virus infection').
write_problem(overheating)       :- write('Computer is overheating').
write_problem(disk_failure)      :- write('Possible hard disk failure').
write_problem(slow_computer)     :- write('Computer is running slowly').

% =========================================
% REPAIR SUGGESTIONS
% =========================================

suggest_fix(no_power) :-
    write('Suggested Fixes:'), nl,
    write('  1. Check the power cable is firmly plugged in at both ends.'), nl,
    write('  2. Try a different power outlet or power strip.'), nl,
    write('  3. For laptops: check battery and charger connection.'), nl,
    write('  4. Hold the power button 10 seconds, then retry.'), nl,
    write('  5. Test the power supply unit (PSU) on a desktop.'), nl.

suggest_fix(blank_screen) :-
    write('Suggested Fixes:'), nl,
    write('  1. Check the monitor cable (HDMI/DisplayPort/VGA) at both ends.'), nl,
    write('  2. Try a different cable or monitor port.'), nl,
    write('  3. Re-seat the RAM sticks firmly.'), nl,
    write('  4. Ensure the GPU is properly seated in the PCIe slot.'), nl,
    write('  5. Try booting with only one RAM stick.'), nl.

suggest_fix(boot_failure) :-
    write('Suggested Fixes:'), nl,
    write('  1. Run Startup Repair from a Windows/Linux USB drive.'), nl,
    write('  2. In BIOS, confirm the correct drive is the boot device.'), nl,
    write('  3. Note any on-screen error codes and search them online.'), nl,
    write('  4. Use System Restore to roll back to a working state.'), nl,
    write('  5. Re-seat or replace the storage drive if errors persist.'), nl.

suggest_fix(peripheral_issue) :-
    write('Suggested Fixes:'), nl,
    write('  1. Unplug and re-plug keyboard/mouse USB cables.'), nl,
    write('  2. Try different USB ports.'), nl,
    write('  3. Test the devices on another computer.'), nl,
    write('  4. Update or reinstall drivers in Device Manager.'), nl,
    write('  5. Replace batteries or re-pair wireless devices.'), nl.

suggest_fix(audio_issue) :-
    write('Suggested Fixes:'), nl,
    write('  1. Check volume and confirm the system is not muted.'), nl,
    write('  2. Run the Audio Troubleshooter (Windows Sound Settings).'), nl,
    write('  3. Confirm the correct playback device is selected.'), nl,
    write('  4. Update or reinstall audio drivers.'), nl,
    write('  5. Test headphones to isolate speaker vs. software fault.'), nl.

suggest_fix(no_internet) :-
    write('Suggested Fixes:'), nl,
    write('  1. Forget the Wi-Fi network and reconnect.'), nl,
    write('  2. Restart your router and modem (wait 30 seconds).'), nl,
    write('  3. Run the Network Troubleshooter / Wireless Diagnostics.'), nl,
    write('  4. Update the Wi-Fi adapter driver.'), nl,
    write('  5. Try an ethernet cable to confirm the router is working.'), nl.

suggest_fix(wired_issue) :-
    write('Suggested Fixes:'), nl,
    write('  1. Check the ethernet cable at both ends.'), nl,
    write('  2. Try a different cable or router port.'), nl,
    write('  3. Restart your router and modem (wait 30 seconds).'), nl,
    write('  4. Run in Command Prompt: ipconfig /release then /renew'), nl,
    write('  5. Contact your ISP if the problem continues.'), nl.

suggest_fix(malware_suspected) :-
    write('Suggested Fixes:'), nl,
    write('  1. Disconnect from the internet immediately.'), nl,
    write('  2. Run a full scan with Windows Defender or Malwarebytes.'), nl,
    write('  3. Uninstall suspicious or recently added programs.'), nl,
    write('  4. Restore to a System Restore point before symptoms began.'), nl,
    write('  5. Reinstall the OS if the infection cannot be removed.'), nl.

suggest_fix(overheating) :-
    write('Suggested Fixes:'), nl,
    write('  1. Clean dust from vents and fans with compressed air.'), nl,
    write('  2. Place the computer on a hard flat surface for airflow.'), nl,
    write('  3. Confirm all internal fans are spinning.'), nl,
    write('  4. Reapply thermal paste to the CPU.'), nl,
    write('  5. Use HWMonitor to check CPU and GPU temperatures.'), nl.

suggest_fix(disk_failure) :-
    write('Suggested Fixes:'), nl,
    write('  1. BACK UP YOUR DATA IMMEDIATELY.'), nl,
    write('  2. Run: chkdsk /f /r in Command Prompt (Windows).'), nl,
    write('  3. Check drive health with CrystalDiskInfo (S.M.A.R.T.).'), nl,
    write('  4. Try a different SATA cable or port (desktop).'), nl,
    write('  5. Replace the drive if errors are confirmed.'), nl.

suggest_fix(slow_computer) :-
    write('Suggested Fixes:'), nl,
    write('  1. Restart the computer to clear memory.'), nl,
    write('  2. Open Task Manager and close high CPU/RAM processes.'), nl,
    write('  3. Disable unnecessary startup programs.'), nl,
    write('  4. Run OS updates (Windows Update / Software Update).'), nl,
    write('  5. Upgrade RAM or replace HDD with an SSD.'), nl.

% =========================================
% ASK — asks once, caches the answer
% =========================================

ask(Key, _Question) :-
    answer(Key, _), !.        % Already answered — skip entirely
ask(Key, Question) :-
    format(atom(Prompt), '~w? (yes/no): ', [Question]),
    write(Prompt),
    read_valid(Key).

% =========================================
% INPUT READER
% =========================================

read_valid(Key) :-
    catch(
        read_term(Input, [variable_names(_)]),
        _,
        ( write('  Read error. Please type yes. or no. : '),
          read_valid(Key) )
    ),
    handle_input(Key, Input).

handle_input(Key, yes)  :- !, assertz(answer(Key, yes)), log_answer(Key, yes).
handle_input(Key, no)   :- !, assertz(answer(Key, no)),  log_answer(Key, no).
handle_input(Key, help) :- !,
    nl,
    write('  [Help] Type yes. or no. followed by a full stop, then Enter.'), nl,
    write('  Example:  yes.  or  no.'), nl, nl,
    write('Continue: '),
    read_valid(Key).
handle_input(Key, _) :-
    write('  Invalid input. Please type yes. or no. : '),
    read_valid(Key).

% =========================================
% REASONING TRACE
% =========================================

log_answer(Key, Val) :-
    format(atom(Entry), '~w -> ~w', [Key, Val]),
    assertz(trace_log(Entry)).

print_trace :-
    nl,
    write('--- Reasoning Trace ---'), nl,
    print_trace_lines,
    write('-----------------------'), nl.

print_trace_lines :-
    trace_log(Entry), write('  * '), write(Entry), nl, fail.
print_trace_lines.

% =========================================
% RESET
% =========================================

reset :-
    retractall(answer(_, _)),
    retractall(trace_log(_)).