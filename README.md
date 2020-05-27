# Introduction to the Tidyverse  

## To Do

* [ ] Edit Text
* [ ] Crete Supplementary R Script
* [ ] Create Supp R Markdown 

No introduction to the R programming language in 2020 would be complete without an introduction to the [tidyverse](https://www.tidyverse.org/).
According to tidyverse website,

> The tidyverse is an opinionated collection of R packages designed for data science. All packages share an underlying design philosophy, grammar, and data structures.

While there's no way to cover everything you would need to know to be a tidyverse master in the next few lessons, the next few lessons will show you some of what the tidyverse has to offer. 

## Learning Objectives  

By the end of this lesson you will be able to:

* [ ] Explain the basic rationale behind tidy data and why a suite of software was built around this principle
* [ ] Name major packages in tidyverse and what they are meant to do 
* [ ] Use `select()`, `filter()`, `group_by()`, `summarise()`, and `arrange()` to manipulate and collapse tibbles (the tidyverse data frame)
* [ ] Use the pipe operator `%>%` from the magrittr package in conjunction with the functions above

## Tidyverse 

Most of data science is cleaning data and the small majority that is left after cleaning is normally spent about talking about cleaning data.
If anything is left after that, you can actually run your models.

By this point, you have a lot of lived experience cleaning data and hopefully recognize how helpful it can be when people create tools that help with this process.
In the world of R, a growing set of tools has been developed over the past decade or so that has tried to make working with data easier called the Tidyverse.

There's a wealth of information you can read about ranging from [this blog post]()(https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html) to the actual [paper](https://vita.had.co.nz/papers/tidy-data.html) that was written about tidy principles, but for our purposes we just have to know that the tidyverse is a set of package that work together because the "share common data representation and API design".

One you have data in a tidy format-- meaning each variable is a column, each observation is a row, and each type of observational unit forms a table-- you can go to town on your data set with the tidyverse!

We had you download the tidyverse in step one of this tutorial, but if you have skipped that you need to run the below command in your R console.
If you're prompted to download more software, make sure to do that! 

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

There is also `tidymodels`, which for learning purposes will be the "sci-kit learn" of the tidyverse. 

We won't get to everything, but if you do want to do a proper dive into the tidyverse, your best place to go learn is [R for Data Science](https://r4ds.had.co.nz/).

## Five Verbs 

Let's now continue to explore the tidyverse with the `dplyr` package.
Here we'll learn about five verbs that you will probably use most frequenlty in your data cleaning, as well as the pipe operator.

This first bit of code that you need to run in RStudio grabs a few different libraries we will be using then we import in the `tips.csv` data set as the object `tips` as a special type of data frame in the tidyverse called a tibble. 

```{r}
library(dplyr) # for manipulating data
library(readr) # for getting data
library(ggplot2) # for plotting data

tips <- read_csv("tips.csv")

# You can change where this is output above in "Settings (by knit) > Chunk Output in Console"
tips

```

The first verb we will use is `select()` which lets us choose which columns we are interested in working with.

```{r}
select(tips, total_bill)
```

The `select()` command takes two arguments here.
The first argument is the data frame that we want to begin to manipulate.

> Notice here that with `select()` and future dplyr verbs, the first argument that the function expects is the tibble we want to manipulate.
This is going to become very important very soon. 

The second argument that `select()` will take are what columns we want to ... select.
In this example, we only get the column `total_bill`. 

Now we often don't just want one column, sometimes we want more than that! 
We can just keep adding whatever columns we need with more arguments.

```{r}
select(tips, total_bill, tip, sex, smoker, day, time, size)
```

Now this is a lot to type out.
The cool thing about `dplyr` is that you can use some of the same operators you would used on numbers on columns.
The call below gives us the exact same output as before but is a bit more concise. 

```{r}
select(tips, total_bill:size)
```

But maybe the reason that we are doing this is just because we want to drop that `X1` column that came for the ride because we've imported this `pandas` data frame.
Instead of saying what columns we do want, it might be easier to just say what we don't want.


```{r}
select(tips, -X1)
```

Again, we see the same output! 

Now this is all pretty basic, but there are a couple of other cool things you should know about.
For example, the `select()` function also has an argument `starts_with()` that takes a character! 

```{r}
select(tips, starts_with("s"))
```

And of course if there's a `starts_with()`, there's also an `ends_with()`.

If you're going to be using dplyr a lot, it's worth [reading a bit of the documentation on it](https://dplyr.tidyverse.org/reference/select.html) as some functions like `pivot_longer()`, which is used to take wide data to long format data, use `select()` syntax. 

So if select is for columns, the what do we have for rows?
It's a function called `filter()`.

Filter works very much like `select()` in that as a function, the first argument it expects is the data frame where you want to pick specific rows to subset out. 

It can deal with both numeric and character input as seen below as well as conditional operators! 

Try to run the code below and see what it does. 

```{r}

filter(tips, day == "Sun")

filter(tips, tip > 5)

filter(tips, sex == "Male" & smoker == "Yes")

filter(tips, sex == "Male" | smoker == "Yes")

```

Now if you want to have a lot of combinations of `filter()` and `select()`, there are ways to do this that are not saving a bunch of intermediary objects together, but if you're thinking about that now, just hold on, we're going to show you a much better way than doing that! 

So now we know how to pick apart a data frame based on either columns or rows, but what if we want to make new variables on the fly, just like in `pandas`?

For that, we are going to use the `mutate()` function. 

Let's return to our example from before where we wanted to convert the data in our `tips.csv` data set from USD to GBP.
Right now, the conversion rate is that 1 USD is about .82 GBP.

Again, the way the syntax works is that the first argument of `mutate()` expects the data frame that we are going to manipulating.
The next argument is the creation of a new variable.
In this case, we are creating a new variable called `gbp_total` and then using the `=` operator to tell `mutate()` what we want that new variable to be.
Here all we need to do is then take the variable we want to manipulate and multiple it by `.82`.
Since R does element wise execution, what's happening under the hood is every element in the column `total_bill` gets multiplied by .82 and is added to a new column of the original data frame. 
We'll also do this for the tip variable.
Notice that we just separate the two different variables within `mutate()` with a comma to say these are separate arguments. 

```{r}
mutate(tips, gbp_total = total_bill * 0.81)

# R doesn't care about spacing!! 
mutate(tips, 
       gbp_total = total_bill * 0.81,
       gbp_tip = tip * 0.81)

```

Up until this point, we have been doing some very basic commands.

What if we want to get a bit more sophisticated?
Let's say we only wanted a few columns and rows selected based on a some selection criteria.
For example, let's only look at the columns `smoker` and `total_bill_gbp`, but only where `gbp_tip` is more than a fiver (£5).

Now if we were doing this like we have been above, it might look something like this.

```{r}
my_first_subset <- select(tips, smoker, tip)
my_second_subset <- mutate(my_first_subset, gbp_tip = tip * .82)
my_data_frame_i_actually_wanted <- filter(my_second_subset, gbp_tip >= 5)

my_data_frame_i_actually_wanted
```

That's OK, but kind of a pain to read.
We have to keep track of intermediate variables, figure out what to name them, and doing this makes us kind of bound to this order of code. 

Since this is something we do a lot of in data science, there's actually a really slick way of getting around this problem with something called the pipe operator `%>%` from the magrittr package.

Let's first look at the code above re-written with the pipe operator, then see if we can figure out what it's doing. 

```{r}
tips %>%
  select(smoker, tip) %>%
  mutate(gbp_tip = tip * .82) %>%
  filter(gbp_tip >= 5)
```

This is a lot more compact and hopefully easier to read!

So what's going on here?

Well remember what we said before about it being really important that the first argument of a `dplyr` verb wanting the tibble (data frame)?
That's where the secret sauce is, what is happening is that the first object, in this case `tips` is getting passed through the pipe and secretly becoming the first argument of the next line.
You can think of it as the code reading:

"Start with the `tips` tibble and then select the `smoker and tip columns"

```{r}

tips %>% # and then !
  select(smoker, tip)

```

Whatever tibble is created from this process then gets passed to the next pipe.
The great thing about this is that you can join up as many pipes as you'd like!
From here we can then build up much more complex commands.

For example, based on what we have learned thus far, can you figure out what the code below is doing? 

```{r}
tips %>%
  select(total_bill, tip, sex, smoker) %>%
  filter(sex == "Male" & smoker == "Yes") %>%
  mutate(gbp_total_bill = total_bill * 0.82,
         gbp_tip = tip * 0.82)

```

Most of what we have learned thus far is how to break down or add on to a tibble that we already have.
But what if we want to start collapsing it down based on some parameters?
For example, in our current state, we can't figure out the average tip between smokers and non-smokers.

For that we need both the `group_by()` and `summerise()` functions. 

```{r}
tips

tips %>%
  group_by(smoker)
```

To get an idea of what `group_by()` is doing, run the two lines above and look for some difference in the output of your code. 
In the second bit of code, you'll see that because you passed the `group_by()` argument, the table is now split into two different groups as noted by the little `Groups: smoker [2]` in the output.
Try and see what happens when you pass the `size` variable (a double) instead of a character variable!

So on its own, it's not that helpful, but we can use this in conjunction with the `summerise()` function.
The `summerise()` function works very much like `mutate()`.
Look at the code below and see if you can notice any similarities between the code here and what `mutate()` did above. 


```{r}
tips %>%
  group_by(smoker) %>%
  summarise(mean_tip = mean(tip),
            count = n())
```

Here we group our data set into two groups on the variable `smoker`, then figure out the average tip per group and call it a new variable called `mean_tip`.
We also make a new variable called `count` using the special function `n()`.

Lastly let's arrange our output here so that those who tip more are on top! 
This isn't the biggest problem in our little, chopped down data set here, but by this point you can imagine why this next command might be helpful.

```{r}
tips %>%
  group_by(smoker) %>%
  summarise(mean_tip = mean(tip),
            count = n()) %>%
  arrange(desc(mean_tip))
```

Now that was a lot of information!
This this lesson we covered five of the major `dplyr` verbs and had an introduction to the pipe operator.

