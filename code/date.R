#!/usr/bin/env Rscript
#
# Summary
#
# Find time zone using `OlsonNames()`.
# Use `lubridate::with_tz()` to output datetimes in different time zones.
# Use `format_ISO8601()` to output datetime in the ISO 8601 format.
# Add or subtract seconds from `Sys.time()` to get future or past datetimes.
#
suppressPackageStartupMessages(library(lubridate))

# helper function to print a command and its output
print_cmd <- function(cmd){
   res <- eval(parse(text = cmd))
   print(paste0('`', cmd, '`', " returns ", '`', res, '`'))
}

# To find your time zone use the function OlsonNames(), which outputs all
# supported time zones in R, together with grep(). It's called Olson because
# that's the surname of the founding contributor.
print_cmd('grep("Australia", OlsonNames(), value = TRUE)')

# The with_tz() function from the lubridate package allows us to output
# datetimes at different time zones.
print_cmd("with_tz(Sys.time(), 'Asia/Tokyo')")
print_cmd("with_tz(Sys.time(), 'Australia/Perth')")
print_cmd("with_tz(Sys.time(), 'UTC')")

# To generate the current time in UTC according to ISO 8601, we can use the
# following code; the Z is the time zone designator for UTC time.
print_cmd("paste0(format_ISO8601(with_tz(Sys.time(), 'UTC')),'Z')")

# previous day
print_cmd("Sys.time()-60*60*24")
