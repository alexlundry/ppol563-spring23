PPOL 563 - Week 3: Exploratory Data Analysis in R
================

For this demonstration and the ensuing exercise we will be using the
[Gapminder](https://www.gapminder.org/) dataset.

``` r
# install.packages("gapminder")
# load necessary libraries
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.1     ✔ purrr   1.0.1
    ## ✔ tibble  3.1.8     ✔ dplyr   1.1.0
    ## ✔ tidyr   1.3.0     ✔ stringr 1.5.0
    ## ✔ readr   2.1.4     ✔ forcats 1.0.0
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(gapminder)
```

## Dataset Overview

First and foremost, we need to understand the library we just loaded.
Using R’s built-in help function gives us helpful information:

``` r
help(package = "gapminder")
```

From here, we can see there are two datasets available: `gapminder` and
`gapminder_unfiltered`. We can again use the help option to get more
information:

``` r
help(gapminder)
help(gapminder_unfiltered)
```

From here, it’s helpful to get a bird’s eye view of the datasets.

This is easily accomplished with the `glimpse` function. The function
provides us with a succinct look at the row and column count, each
variable and it’s corresponding type, and a brief look at the first few
observations.

Here it is for the `gapminder` dataset:

``` r
glimpse(gapminder)
```

    ## Rows: 1,704
    ## Columns: 6
    ## $ country   <fct> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan", …
    ## $ continent <fct> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, …
    ## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, …
    ## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.854, 40.8…
    ## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 12…
    ## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 786.1134, …

And here it is for the unfiltered dataset:

``` r
glimpse(gapminder_unfiltered)
```

    ## Rows: 3,313
    ## Columns: 6
    ## $ country   <fct> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan", …
    ## $ continent <fct> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, …
    ## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, …
    ## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.854, 40.8…
    ## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 12…
    ## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 786.1134, …

We immediately see that the “clean” dataset has 1,704 rows while the
“dirty” one has 3,313. The columns (variables) are identical between the
two.

We know there are two categorical variables (country and continent), a
year designation, and the remainder are numeric.

Of course, sometimes you just want to look at the data:

``` r
# View(gapminder_unfiltered)
```

## Variable Understanding - Categorical Vars

Once you have a bird’s eye view of the data, you need to dig into the
variables themselves, asking yourself a few key questions:

- What variables do I have?
- What type of variation occurs within my variables?
- Which values are most common? Why?
- Which values are rare? Why? Does that match expectations?
- Can you see any unusual patterns? What might explain them?

How we understand the variation will depend upon whether the variable is
categorical or continuous.

There are two categorical variables in our data: `country` and
`continent`. For each, a simple bar chart will tell us a lot:

``` r
ggplot(gapminder_unfiltered, aes(continent)) +
   geom_bar()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Remember your ggplot syntax! Ggplot takes as parameters a dataset, and
then you must map it’s aesthetic components. The aesthetics are what you
are encoding the data as. So, in this one, we are encoding continent as
the X aesthetic (I haven’t explicitly declared it here - remember that
ggplot is really good at understanding what aesthetics you mean). Once
we have set the baseline we must tell ggplot how to encode data behind
continent…here we are telling it to show it as a bar. It’s default
behavior is to render a count of the x aesthetic as a bar.

Back to the data: This bar chart is great, but what the heck is FSU?

``` r
gapminder_unfiltered %>% 
   filter(continent == "FSU") %>% 
   count(country)
```

    ## # A tibble: 9 × 2
    ##   country        n
    ##   <fct>      <int>
    ## 1 Armenia        4
    ## 2 Belarus       18
    ## 3 Georgia        9
    ## 4 Kazakhstan     4
    ## 5 Latvia        42
    ## 6 Lithuania     18
    ## 7 Russia        20
    ## 8 Ukraine       20
    ## 9 Uzbekistan     4

Aha! FSU == Former Soviet Union.

We use some of our basic dplyr tools (plus the pipe!) to figure that
out. We declare the dataset, pipe it into a filter statement, where
continent equals FSU, and then send that to a count function for
country.

Let’s get a sense of how many countries there are and how many entries
each has:

``` r
count(gapminder_unfiltered, country, sort = T)
```

    ## # A tibble: 187 × 2
    ##    country             n
    ##    <fct>           <int>
    ##  1 Czech Republic     58
    ##  2 Denmark            58
    ##  3 Finland            58
    ##  4 Iceland            58
    ##  5 Japan              58
    ##  6 Netherlands        58
    ##  7 Norway             58
    ##  8 Portugal           58
    ##  9 Slovak Republic    58
    ## 10 Spain              58
    ## # … with 177 more rows

We use another count function, this time on all countries, with the
option of sort = True to see how frequently countries appear in the
data.

So we know there ar 187 unique countries and that the max number of
observations is 58.

Let’s see how many countries meet that criteria by visualizing the count
data table as a histogram.

``` r
gapminder_unfiltered %>% 
   count(country) %>% 
   ggplot(aes(n)) +
   geom_histogram()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](EDA-in-R_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

Pipe the count datatable into ggplot, where we want to visualize the
variable “n” as our X aesthetic. And how do we visualize that aesthetic?
As a histogram.

Remember here that ggplot does NOT use the pipe. As Hadley says, it was
built before the pipe was discovered, so it uses the + sign as it’s
linking mechanism.

This probably varies greatly by year. Let’s see what this looks like for
year:

``` r
gapminder_unfiltered %>% 
   count(year) %>% 
   ggplot(aes(year, n)) +
   geom_line()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

We pipe the dataset into a count function based on year, then pipe that
into ggplot, here we declare two aesthetics, x and then y, year and
n. We visualize the aesthetic as a line.

Some interesting periodicity. Clearly we are getting the maximum (or
near maximum) number of observations in years ending in 2 and 7. And
there seems to be a core of about 25 countries that are observed every
year.

## Data Cleaning

All the variable understanding above has moved us to a point where we
are ready to clean up the data. Typically data cleaning in your initial
exploration would focus on:

- Removing redundant variables
- Variable selection
- Removing outliers

The variables in the dataset are already pretty limited - I don’t see
much fat to cut. So we’ll skip right to removing outliers. In this
particular dataset it’s more a question of limiting our data only to
those countries that have a high number of observations.

For our purposes, let’s limit this to its most recent 30 year span, and
take only countries that show up at least 25 times:

``` r
d1 <- gapminder_unfiltered %>% 
   filter(year >= 1977) %>% 
   group_by(country) %>% 
   mutate(n_obs = n()) %>% 
   filter(n_obs >= 25)
```

We create a new dataset called d1 by piping the unfiltered data into a
filter function where year is \>= 1977, then for each country, we count
(that’s the n function) how many times it shows up, and we then filter
it to see only those countries that have 25 or more observations.

Notice here that I used a group_by function on country, but that was NOT
followed by a summarize function. It was instead followed by a mutate
function. A summarize would have “rolled-up” the data by country, but
since we used a mutate function, it is instead appending a rolled up
number by country to each individual data point for that country. It is
a way to attach a grouped summary variable to non-summarized data.

Let’s see what that looks like by country:

``` r
ggplot(d1, aes(fct_infreq(country))) +
   geom_bar() +
   coord_flip()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

The fct_infreq function comes from the forcats package; it allows us to
sort the country variable by frequency.

We can then filter the data down to just those countries with a few
dplyr moves.

From that filtered data set we extract just the names of the countries
as a vector. We pipe d1 into a select statement of just the country
variable, then turn it into a vector.

``` r
filtered_countries <- d1 %>% 
   select(country) %>% as_vector()
```

We then take the unfiltered data, pipe that into a filter statement that
use the very useful %in% function to filter to just those countries,
plus the year filter.

``` r
d2 <- gapminder_unfiltered %>% 
   filter(country %in% filtered_countries,
          year >= 1977)
```

## Variable Understanding: Continuous Variables

Now let’s focus on understanding our continuous variables. (We’ll
continue to use the unfiltered data just to simulate EDA on a larger
dataset). Here we’ll look specifically at `gdpPercap`. First step here
is to run a basic histogram to get a sense of the “shape” of the data:

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap)) +
   geom_histogram()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](EDA-in-R_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

Our aesthetic is `gdpPercap`

A histogram divides the x-axis into equally spaced bins and then uses
the height of a bar to display the number of observations that fall in
each bin. The tallest bar shows that about 700 observations are
clustered around the lowest possible Per Capita GDP.

Moreover, the histogram shows that there is not a ton of variability
here. High kurtosis (mode is more common than it would be in a normal
distribution).

Note that the histogram defaulted to 30 “bins” of the data. You can
rerun the histogram with a different number of bins OR you can designate
the bin width. This could really change the “look” of the data, so you
should always try a bunch of different bin widths, because it could
reveal different patterns.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap)) +
   geom_histogram(binwidth = 1000)
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

We can also use a boxplot on this, but, as you’ll see below, I don’t
think it’s as useful as the histogram version.

Notice that the aesthetic statement is the same, but we’ve simply
changed the geom. Now it is a geom_boxplot. I’ve also flipped the axes
just to make it more readable, using a coord_flip function. This is a
frequent easy change to make.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap)) +
   geom_boxplot() +
   coord_flip()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

Boxplots are odd, but can be incredibly useful (invented by Tukey, btw).
Here’s a great description of how they work. The box itself represents
the interquartile range, running from the 25th %tile to the 75th %tile,
with the bar in the middle representing the median. The whiskers extend
out to the farthest non-outlier point. And outliers are shown as dots.

![](https://d33wubrfki0l68.cloudfront.net/153b9af53b33918353fda9b691ded68cd7f62f51/5b616/images/eda-boxplot.png)

## Covariation: Analyzing relationships between variables

### Continuous / Categorical interaction

There’s probably some big variation here depending upon other factors
like `region` so let’s look at that by using `facet_wrap()` a VERY
useful tool for EDA that panels your plot by a categorical variable of
your choosing. The facet_wrap function takes a variable that you want to
show small multiples for (or, as its called here, a facet)

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap)) +
   geom_histogram() +
   facet_wrap(~ continent)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](EDA-in-R_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

We could again do this through boxplots:

``` r
ggplot(gapminder_unfiltered, aes(x = continent, y = gdpPercap)) +
   geom_boxplot()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

That’s a lot more useful than our previous histogram. We don’t have as
much information as we got with the faceted bars, but everything is more
compact so we can more easily compare them.

Note here that we are designating an x and y aesthetic, and explicitly
declaring it just for clarity here. No need for coord_flip because we
have mapped the Y axis to the numeric variable.

We can also do a little manipulation of this to make it slightly more
readable. We do this by using a reorder function in the x aesthetic
declaration, telling it to reorder continent by gdpPercap, based on a
median function.

``` r
ggplot(gapminder_unfiltered, aes(x = reorder(continent, gdpPercap, FUN = median), y = gdpPercap)) +
   geom_boxplot()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

Flipping this might also help (We could also have simply reversed the X
and Y declarations, but this is easier (imho)).

``` r
ggplot(gapminder_unfiltered, aes(x = reorder(continent, gdpPercap, FUN = median), y = gdpPercap)) +
   geom_boxplot() +
   coord_flip()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

Let’s revisit the facet, but instead of using counts, we can use
`after_stat(density)` as the y argument in the `aes` function. This
let’s use see the values as a relative measurement rather than an
absolute count - so that we can better see the patterns in other areas.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, after_stat(density))) +
   geom_histogram() +
   facet_wrap(~ continent)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](EDA-in-R_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

You’ll notice that in this and the previous facet examples, the facets’
axes were fixed. You can change this in an argument to `facet_wrap`,
where you can set `scales = "free"` to have both x and y vary in each
facet, or you could also set them either `free_x` or `free_y`:

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, after_stat(density))) +
   geom_histogram() +
   facet_wrap(~ continent, scales = "free")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](EDA-in-R_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

### Numeric / Numeric interaction

A very useful option for visual EDA is the `pairs` function that comes
as part of R’s base graphics option:

``` r
pairs(gapminder_unfiltered)
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

Each text box represents a variable, each of the graphics in the row of
that text box has that variable as the X axis, while each of the
graphics in the column of that text box has that variable as the Y-axis.

Of course, it’s still pretty hard to understand - the boxes are small
and the `country` and `continent` graphs are odd because they’re
categorical data. Let’s get rid of them using a smart select function -
the `select_if()` function and the declaration `is.numeric` - it only
selects the numeric variables.

``` r
gapminder_unfiltered %>% 
   select_if(is.numeric) %>% 
   pairs
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

This is easier to read; life expectancy generally increases over time
and with higher GDP, and population and GDP both increase over time.
Most importantly, it doesn’t point to anything especially wrong with our
data.

## Analyzing Patterns

Now we move into the next part of EDA, in which we’ve gone beyond data
understanding, data cleansing and looking for mistakes. Now we start to
look at patterns and see if we can find anything interesting in the
data. You’re going to run into dead ends, but this is how you refine
your analysis.

More specifically, you are going to engage in an iterative cycle of:

- Generate questions about your data
- Search for answers by visualizing, transforming, and modelling your
  data
- Use what you learn to refine your questions and/or generate new
  questions.

Let’s look specifically at the first pattern we noticed in the `pairs`
chart above - the relationship between GDP and life expectancy.

We declare these as our aesthetics and then the geom mapping we use is
geom_point. It gives us a scatterplot.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, lifeExp)) +
   geom_point()
```

![](EDA-in-R_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

This is pretty interesting! It appears as though higher GDP is
associated with higher life expectancy, but only to a point. Let’s put a
trend line through it to see what the model tells us. We can do this
with a simple addition of a smooth geom

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, lifeExp)) +
   geom_point() +
   geom_smooth()
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](EDA-in-R_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

This sort of shape - where there is an obvious and single curve to the
data - makes me think that log-transforming the data might make sense.
This can be done by adding a scale_x statement; in this case
`scale_x_log10`.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, lifeExp)) +
   geom_point() +
   scale_x_log10() +
   geom_smooth()
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](EDA-in-R_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

This gives us a nice linear relationship.

Let’s think about how other variables come into play here. Certainly
this will vary by continent, so let’s add faceting by continent, and set
the scales to free.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, lifeExp)) +
   geom_point() +
   geom_smooth() +
   scale_x_log10() +
   facet_wrap(~ continent, scales = "free") 
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](EDA-in-R_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

You might also think about how it varies by year. We can add year to the
previous chart encoded by color. Notice here that we are declaring an
aesthetic in the geom_point statement, and that we are explicitly
declaring color mapped to year.

``` r
ggplot(gapminder_unfiltered, aes(gdpPercap, lifeExp)) +
   geom_point(aes(color = year)) +
   geom_smooth() +
   scale_x_log10() +
   facet_wrap(~ continent, scales = "free") 
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](EDA-in-R_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

This helps. You can see that a lot of the darker (older) dots are lower
on the life expectancy axis, while lighter (newer) are higher. Let’s do
a more direct comparison here between different epochs of data. You’ll
see a key mutate statement up front with an ifelse statement, piped into
ggplot.

``` r
gapminder_unfiltered %>% 
   mutate(epoch = ifelse(year < 1980, "pre-1980", "1980 +")) %>% 
   ggplot(aes(gdpPercap, lifeExp)) +
   geom_point(aes(color = epoch)) +
   geom_smooth() +
   scale_x_log10() +
   facet_wrap(~ continent, scales = "free")
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](EDA-in-R_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

That confirms what we expected, though certainly there are some
interesting outliers.

So we have a pattern, and now we need to ask ourselves some questions
about it:

- Could this pattern be due to coincidence?
- How can you describe the relationship implied by the pattern?
- How strong is the relationship implied by the pattern?
- What other variables might affect the relationship?
- Does the relationship change if you look at individual subgroups of
  data?

## Inspiration & Guidance

- Mike Mahoney’s [“Introduction to Data Exploration and Analysis with
  R”](https://bookdown.org/mikemahoney218/IDEAR/introduction-to-data-analysis.html#exploratory-data-analysis).
- Terence Shin’s [“An Extensive Step by Step Guide to Exploratory Data
  Analysis”](https://towardsdatascience.com/an-extensive-guide-to-exploratory-data-analysis-ddd99a03199e)
