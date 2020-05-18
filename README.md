# Introduction to the Tidyverse  

## To Do

* [ ] Flesh out this lesson
* [ ] Edit Text
* [ ] Crete Supplmentatry R Script
* [ ] Create Supp R Markdown 
* [ ] Explicate dplyr here 

No introduction to the R programming language in 2020 would be complete without an introduction to the [tidyverse](https://www.tidyverse.org/).
According to tidyverse website,

> The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures.

While there's no way to cover everything you would need to know to be a tidyverse master in the next few lessons, the next few lessons will show you some of what the tidyverse has to offer. 

## Learning Objectives  

By the end of this lesson you will be able to:

* [ ] Explain the basic rationale behind tidy data and why a suite of software was built around this principle
* [ ] Name major packages in tidyverse and what they are meant to do 
* [ ] Go over five basic verbs in dplyr 
* [ ] Use the pipe operator `%>%` from the maggritr package 
* [ ] Reproduce a data analysis using tools from the tidyverse that we had done formerly with pandas 

## Tidyverse 

Most of data science is cleaning data and the small majority that is left after cleaning is normally spent about talking about cleaning data.
If anything is left after that, you can actually run your models.
By this point, you have a lot of lived experience cleaning data and hopefully recognize how helpful it can be when people create tools that help with this process.
In the world of R, a growing set of tools has been developed over the past decade or so that has tried to make working with data easier called the Tidyverse.

Where does tidy come from in tidyverse?

* [blog here](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)
* [paper ](https://vita.had.co.nz/papers/tidy-data.html) 

Once data is in this format, the idea is that you can use a whole set of package that work together because the "share common data represations and API design".
All of these packages work together and go under name of "tidyverse".

We had you download the tidvyerse in step one, but if you have skipped that you need to run:

```{r}
# get tidyverse from CRAN
install.packages("tidyverse")
```

Remember, just like `pip` or `conda`, you only have to use `install.packages()` once unless you are updating.

Then once installed, you have to call the software to use it, in our case this will be 

```{r}
library(tidvyerse)
```

When you do this, you end up getting the [core tidyverse packages](https://tidyverse.tidyverse.org/).
We've reproduced the table from the link below here.


|R package name | Description |
|---------------|-------------|
|ggplot2| data visualisation|
|dplyr |data manipulation|
|tidyr |data tidying|
|readr |data import|
|purrr |functional programming|
|tibble |tibbles, a modern re-imagining of data frames|
|stringr |strings|
|forcats |factors|

There is also `tidymodels`, which for learning puposes will be the "sci-kit learn" of the tidvyerse. 

We won't get to everything, but if you do want to do a proper dive into the tidyverse, your best place to go learn is [R for Data Science](https://r4ds.had.co.nz/).

## Five Verbs 

Let's now continue to explore the tidyverse with the `dplyr` package.
Here we'll learn about five verbs and the pipe operator.

```{r}
library(dplyr) # for manipulating data

library(readr) # for getting data
library(ggplot2) # for plotting data

tips <- read_csv("tips.csv")

# You can change where this is output above in "Settings (by knit) > Chunk Output in Console"
tips

```

The first verb we will use is `select()` which lets us choose colunmns. 

```{r}
select(tips, total_bill)

select(tips, -X1)

select(tips, tip:size)

select(tips, starts_with("s"))
```

Now let's check out filter!

```{r}

filter(tips, day == "Sun")

filter(tips, tip > 5)

filter(tips, sex == "Male" & smoker == "Yes")

filter(tips, sex == "Male" | smoker == "Yes")

```

Let's now return to our example from before to see `mutate()` in action. 
It's the same output, but right now looks a bit different since it's simplified.

```{r}
mutate(tips, gbp_total = total_bill * 0.81)

# R doesn't care about spacing!! 
mutate(tips, 
       gbp_total = total_bill * 0.81,
       gbp_tip = tip * 0.81)

```

Up until this point, we have been doing some very basic commands.
What if we want to get super fancy?
We could save a bunch of intermediate objects into memory... or we could use the %>% operator! 

```{r}
select(tips, total_bill)

tips %>%  # and then! 
  select(total_bill)

```

We can then build up more complex commands.

```{r}
tips %>%
  select(total_bill, tip, sex, smoker) %>%
  filter(sex == "Male" & smoker == "Yes") %>%
  mutate(gbp_total_bill = total_bill * 0.81,
         gbp_tip = tip * 0.81)

```

But what if we wanted to investigate differences between smoker and non smokers for tipping?
For that we need `group_by` and summerise! 

```{r}
tips %>%
  group_by(smoker)

tips %>%
  group_by(smoker) %>%
  summarise(mean = mean(tip),
            count = n())

```


Special Character n() here. 

Lastly let's arrange our output here so that those who tip more are on top! 

```{r}
tips %>%
  group_by(smoker) %>%
  summarise(mean = mean(tip),
            count = n()) %>%
  arrange(desc(mean))
```

