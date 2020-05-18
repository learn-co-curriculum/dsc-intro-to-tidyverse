# get tidyverse from CRAN
install.packages("tidyverse")
library(tidvyerse)


# Reduant to call
library(dplyr) # for manipulating data
library(readr) # for getting data
library(ggplot2) # for plotting data

tips <- read_csv("data/tips.csv")

# You can change where this is output above in "Settings (by knit) > Chunk Output in Console"
tips

select(tips, total_bill)

select(tips, -X1)

select(tips, tip:size)

select(tips, starts_with("s"))

filter(tips, day == "Sun")

filter(tips, tip > 5)

filter(tips, sex == "Male" & smoker == "Yes")

filter(tips, sex == "Male" | smoker == "Yes")

mutate(tips, gbp_total = total_bill * 0.81)

mutate(tips, 
         gbp_total = total_bill * 0.81,
         gbp_tip = tip * 0.81)

select(tips, total_bill)

tips %>%  # and then! 
  select(total_bill)

tips %>%
  select(total_bill, tip, sex, smoker) %>%
  filter(sex == "Male" & smoker == "Yes") %>%
  mutate(gbp_total_bill = total_bill * 0.81,
         gbp_tip = tip * 0.81)

tips %>%
  group_by(smoker)

tips %>%
  group_by(smoker) %>%
  summarise(mean = mean(tip),
            count = n())

tips %>%
  group_by(smoker) %>%
  summarise(mean = mean(tip),
            count = n()) %>%
  arrange(desc(mean))

