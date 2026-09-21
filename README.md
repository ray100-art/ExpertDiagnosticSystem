# Expert Diagnostic System — Computer Troubleshooting in Prolog

A rule-based **expert system** that diagnoses common computer faults by asking yes/no
questions, the way a support technician would. It walks a decision tree, reaches a diagnosis,
suggests step-by-step fixes, and then **explains its reasoning** by printing every answer
that led to the conclusion.

## What it can diagnose

| Diagnosis | Diagnosis |
|---|---|
| No power | No internet (Wi-Fi) |
| Blank or black screen | No internet (wired) |
| Boot failure or OS error | Possible malware |
| Keyboard or mouse not working | Overheating |
| No sound | Possible hard-disk failure |
| Running slowly | No problem detected |

## Example session

```
Is the computer turning on at all? (yes/no): no.

==================================================
DIAGNOSIS: Computer has no power
==================================================

Suggested Fixes:
  1. Check the power cable is firmly plugged in at both ends.
  2. Try a different power outlet or power strip.
  ...

--- Reasoning Trace ---
  * power_on -> no
```

## How it's built

- **Knowledge base as a decision tree.** Each level asks one question and branches into two
  sub-trees, so no question is asked twice on any path.
- **Working memory.** Answers are stored as dynamic facts (`answer/2`). A question that has
  already been answered is skipped.
- **Explanation facility.** Every answer is logged (`trace_log/1`) and printed after the
  diagnosis. This transparency is a defining feature of expert systems.
- **Robust input.** Anything other than `yes.` or `no.` is re-prompted, and `help.` shows
  guidance at any question.

## Run it

Requires [SWI-Prolog](https://www.swi-prolog.org/).

```bash
swipl expertsystem001.pl
?- start.
```

Answer each question with `yes.` or `no.` (including the full stop).

## License

[Apache 2.0](LICENSE)
