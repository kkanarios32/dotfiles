#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " | "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 1

// Define blocks for the status feed as X(icon, cmd, interval, signal).
#define BLOCKS(X)              \
    X("", "pomo clock", 1, 8)  \
    X("", "sb-time", 60, 6)    \
    X("", "sb-date", 10000, 5) \
    X("", "sb-battery", 1, 3)
/* X("", "sb-volume", 1, 4) \ */
/* X("", "sb-network", 1, 1) \ */
/* X("", "sb-bluetooth", 10, 2) \ */
/* X("", "sb-vpn", 10, 7) \ */
#endif  // CONFIG_H
