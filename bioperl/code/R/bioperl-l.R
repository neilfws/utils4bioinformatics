# bioperl-l R
# plot the size of the monthly archives from bioperl-l mail list

library(XML)
library(stringr)
library(ggplot2)

# download and get 1st table in list
bp   <- readHTMLTable("http://lists.open-bio.org/pipermail/bioperl-l/", stringsAsFactors = FALSE)
bp   <- bp[[1]]

# get gzip sizes KB or MB
size <- str_match(bp$`Downloadable version`, "Text (\\d+) (\\w+) ")[, 2:3]
bp$size <- as.numeric(size[, 1])
bp$size <- ifelse(size[, 2] == "KB", bp$size * 1024, bp$size)
bp$size <- ifelse(size[, 2] == "MB", bp$size * 1024 * 1024, bp$size)

# parse & convert date
bp$date <- gsub(":", "", bp$Archive)
bp$date <- gsub(" ", " 1 ", bp$date)
bp$date <- as.Date(bp$date, "%B %e %Y")

# plot
ggplot(bp) + geom_bar(aes(date, size), fill = "cornflowerblue", stat = "identity") + theme_bw() + scale_x_date(date_breaks = "2 years") + labs(x = "Date", y = "archive Gzip size (bytes)", title = "Approximate size of monthly Bioperl-l downloadable version 1996-present")
