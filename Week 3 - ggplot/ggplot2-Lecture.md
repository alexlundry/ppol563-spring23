ggplot2 Overview & Demonstration
================

## Intro

Every graph can be described as a combination of independent building
blocks:

- **data**: a data frame: quantitative, categorical; local or database
  query
- **aes**thetic mapping of variable into visual properties: size, color,
  x, y
- **geom**etric objects: points, lines, areas, arrows, …
- **coord**inate system: Cartesian, log, polar, map

We’ll be working with the `gapminder` data again (but this time the
clean/filtered version). Let’s recreate one of the scatterplots we used
in our EDA demo.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0      ✔ purrr   1.0.1 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.1      ✔ stringr 1.5.0 
    ## ✔ readr   2.1.3      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(gapminder)
```

## Layering

ggplot2 builds plots in layers. The first layer is the data. Notice what
happens if you JUST call that one layer…you get a blank canvas.

``` r
ggplot(data = gapminder)
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

The next layer is the aesthetic layer. Here is where you establish what
variables are mapped to the x and y axis. But notice that there’s still
no actual display of the data yet! We haven’t told it what shape to
display it in.

``` r
ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp))
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Then you add the geometric layer, telling ggplot what type of geometric
shape to plot.

``` r
ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp)) +
   geom_point()
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Mappings

Now let’s really dig into it.

The following code makes these calls:

1.  data = gapminder: dataframe
2.  aes(x = gdpPercap, y = lifeExp): plot variables
3.  aes(color = continent): attributes
4.  geom_point(): what to plot

- the coordinate system is taken to be the standard Cartesian (x,y)

``` r
ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp, 
       color = continent)) +
   geom_point()
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

What happens if we change around some of the mappings? You get a graphic
that uses a grammar, but not in a way that makes any sense.

It’s like using words in a grammatically “correct” sentence, but it
makes no sense, like “colorless green data sleep furiously.”

``` r
ggplot(data = gapminder, 
   aes(x = continent, y = country, 
       color = gdpPercap)) +
   geom_bin2d()
```

    ## Warning: The following aesthetics were dropped during statistical transformation: colour
    ## ℹ This can happen when ggplot fails to infer the correct grouping structure in
    ##   the data.
    ## ℹ Did you forget to specify a `group` aesthetic or to convert a numerical
    ##   variable into a factor?

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

## Statistics and Scales

Other ggplot2 building blocks:

- **stat**istical transformations: data summaries like mean, sd, binning
  & counting, …
- **scale**s: legends, axes to allow reading data from a plot

In the next code call,

1.  data = gapminder: dataframe
2.  aes(x = gdpPercap, y = lifeExp): plot variables
3.  aes(color = continent): attributes
4.  geom_point(): what to plot
5.  geom_smooth(): a statistical transformation fits the data to a loess
    smoother, and then returns predictions from evenly spaced points
    within the range of the data.
6.  scale_x\_log10(): transforms the X axis into log scale.

- the coordinate system is taken to be the standard Cartesian (x,y)
- note that color is “inherited” by geom_smooth, so there are 5 trend
  lines.

``` r
ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp, 
       color = continent)) +
   geom_point() +
   geom_smooth() +
   scale_x_log10()
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

*Note that you don’t have to be verbose in your code, ggplot2 makes good
assumptions based on where you put things in the code.*

## Inheritance

That last chart with a trend line for each continent was a bit too much.

- By moving the color specification to geom_point() it is NOT inherited
  further down the syntax.
- (You can also override inheritance by declaring an aesthetic mapping
  in the right geom.)

``` r
ggplot(gapminder, 
   aes(gdpPercap, lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10()
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

## Other Mappings

Let’s see how we can change a few other things:

- Below, we’ve changed the mapping of the color aesthetic to `year`
- Mapped `continent` to shape
- Set the alpha level of the shape to 0.8; alpha tells us how
  transparent to make the mark and runs from 0 (completely transparent)
  to 1 (completely opaque).

This doesn’t build us a very helpful plot for interpretation, but
hopefully it helps YOU see how you can work with different aesthetic
mappings.

``` r
ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp)) +
   geom_point(aes(color = year, shape = continent, size = pop), alpha = 0.8) +
   geom_smooth() +
   scale_x_log10()
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Working With Color

Before we move on to other ggplot2 building blocks, let’s go back to a
reasonable plot, and see what we can do with color.

First, know that you can manually change the colors with
`scale_color_manual`. You can specify 140 colors by name; or you can use
hex.

``` r
ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10() +
   scale_color_manual(values = c("red", "orange", "yellow", "green", "blue"))
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

You can (and probably should) use prebuilt color palettes.

``` r
p2 <- ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10() +
   scale_color_brewer(palette = "Dark2")

print(p2)
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

We can use a colorblindness simulator to see what this palette looks
like to the colorblind. (This package isn’t on CRAN yet, so you need to
install it directly from github, and you may also need to install the
package that allows you to install from github, remotes)

Calling it’s function `cvd_grid` and passing it a graph object will
display what it will look like to people with four different kinds of
color blindness.

``` r
remotes::install_github("clauswilke/colorblindr", quiet = TRUE)
colorblindr::cvd_grid(p2)
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

We can use a built in palette from the `colorblindr` package.

``` r
p3 <- ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10() +
   colorblindr::scale_color_OkabeIto()

print(p3)
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Then we can run that through the simulator to see how it looks:

``` r
colorblindr::cvd_grid(p3)
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

## Faceting

Other ggplot2 building blocks: \* **facet**ing: break a plot into
subsets and display small multiples conditional on another variable

In this call,

1.  data = gapminder: dataframe
2.  aes(x = gdpPercap, y = lifeExp): plot variables
3.  geom_point(): what to plot, with a aes(color = continent) attribute
4.  geom_smooth(): a statistical transformation fits the data to a loess
    smoother, and then returns predictions from evenly spaced points
    within the range of the data.
5.  scale_x\_log10(): transforms the X axis into log scale.
6.  facet_wrap: breaks the plot into subsets and display small multiples
    conditional on the continent variable.

- note that each plot separately uses all of the calls , so there are
  separate geom_smooth lines for each subsetted plot

``` r
ggplot(gapminder, 
   aes(gdpPercap, lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10() +
   facet_wrap(~ continent)
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

One thing you can do to make the facets (potentially) more interesting
is to let the x and/or y axes vary within each plot. You do that by
passing it a `scales` argument of one of the following:

- scales = “fixed”: x and y scales are fixed across all panels
- scales = “free_x”: the x scale is free, and the y scale is fixed
- scales = “free_y”: the y scale is free, and the x scale is fixed
- scales = “free”: x and y scales vary across panels.

``` r
ggplot(gapminder, 
   aes(gdpPercap, lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10() +
   facet_wrap(~ continent, scales = "free")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

You can also use `facet_grid` with two discrete variables to add yet
another layer to your graphic. Since we don’t have another
low-dimensional categorical variable in the dataset, we’ll make one up
to show how it `facet_grid` would work:

``` r
d2 <- gapminder %>% 
   group_by(country) %>% 
   mutate(rand = sample(0:1, n(), replace = TRUE), 
          cool = ifelse(rand == 0, "not cool", "cool"))

ggplot(d2, 
   aes(gdpPercap, lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth() +
   scale_x_log10() +
   facet_grid(continent ~ cool, scales = "free_y")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

## Position Adjustments

Other ggplot2 building blocks: \* **pos**ition adjustments: jitter,
dodge, stack…

Position is most helpful with bar charts, which we’ll show later in this
demonstration, but for now, just to continue with our previous examples,
here’s a plot you’re unlikely to make, but it demonstrates
`position = "jitter"`

> “The jitter geom is a convenient shortcut for geom_point(position
> =”jitter”). It adds a small amount of random variation to the location
> of each point, and is a useful way of handling overplotting caused by
> discreteness in smaller datasets.”

- [ggplot2
  documentation](https://ggplot2.tidyverse.org/reference/geom_jitter)

``` r
ggplot(gapminder, 
   aes(gdpPercap, continent)) +
   geom_point(aes(color = continent), position = "jitter") +
   scale_x_log10()
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

Here’s what it would look like without the `position = jitter` call.

``` r
ggplot(gapminder, 
   aes(gdpPercap, continent)) +
   geom_point(aes(color = continent)) +
   scale_x_log10()
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

Let’s make a bar chart using our data to demonstrate how position can be
used. To make the visualization a bit easier to read and handle (though
it will still be a long way from great!), we are going to limit it to
the top 5 countries on each continent by population in 2007.

First, here is just a regular bar chart, which automatically stacks the
country bars on top of each other. This is `position = "stack"`

``` r
gapminder %>% 
   filter(year == 2007) %>% 
   group_by(continent) %>% 
   arrange(desc(pop)) %>% 
   top_n(5) %>%
   ggplot(aes(continent, pop)) +
   geom_bar(stat = "identity", aes(fill = country)) +
   theme(legend.position = "none")
```

    ## Selecting by gdpPercap

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

Next we use `position = "fill"` to make it a 100% stacked bar chart.
It’s not a great chart, but hopefully you get the point.

``` r
gapminder %>% 
   filter(year == 2007) %>% 
   group_by(continent) %>% 
   arrange(desc(pop)) %>% 
   top_n(5) %>%
   ggplot(aes(continent, pop)) +
   geom_bar(stat = "identity", aes(fill = country), position = "fill") +
   theme(legend.position = "none")
```

    ## Selecting by gdpPercap

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

And finally, we can use `position = "dodge"` to make it a grouped bar
chart. Again, not a great chart, but this should serve for position
demonstration purposes.

``` r
gapminder %>% 
   filter(year == 2007) %>% 
   group_by(continent) %>% 
   arrange(desc(pop)) %>% 
   top_n(5) %>%
   ggplot(aes(continent, pop)) +
   geom_bar(stat = "identity", aes(fill = country), position = "dodge") +
   theme(legend.position = "none")
```

    ## Selecting by gdpPercap

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

## More on Layers

Other ggplot2 building blocks:

- **layer**s: graph elements can be combined with “+”; graphs can be
  saved to a variable and then have layers added on to them iteratively.
- **theme**s: change graphic elements consistently

Below, we create a plot named `p1` which uses a **linear model**
statistical transformation for to display it’s `geom_smooth`. It makes
an aesthetic call to `color=continent` so there are separate linear
trend lines for each continent group.

We can then call `p1` and add another layer on top of it that is
*another* `geom_smooth`, but this one uses the loess method and has a
constant color attribute (instead of mapping any variable onto the color
aesthetic).

Note that this just as easily could have been done in one big ggplot
call with multiple layers, we are just doing it this way to show you how
you can name plots and recall them later to add layers.

``` r
p1 <- ggplot(data = gapminder, 
   aes(x = gdpPercap, y = lifeExp)) +
   geom_point(aes(color = continent)) +
   geom_smooth(method="lm", aes(color=continent))

p1 +
   geom_smooth(method="loess", color="black", se=FALSE) +
   scale_x_log10() 
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

## Themes

Now let’s see what happens when we change a plots theme. ggplot2 comes
with a number of built-in themes that can be easily called. Note if you
haven’t saved a ggplot object, `last_plot()` gives you something to work
with.

``` r
last_plot() + theme_bw()
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

``` r
last_plot() + theme_dark()
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

You can obtain other people’s alternative themes through packages like
`ggthemes`

``` r
last_plot() + ggthemes::theme_economist()
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

``` r
last_plot() + ggthemes::theme_fivethirtyeight()
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

``` r
last_plot() + ggthemes::theme_wsj()
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

``` r
last_plot() + ggthemes::theme_tufte()
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

You can update a theme just by adding another `theme` call:

``` r
last_plot() + 
   theme(legend.position = "top")
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

You can also create custom themes and then use them as needed:

``` r
dra_theme <- theme(plot.title = element_text(size=30, face = "bold", family = "DIN-Bold"),
   legend.position = "top",
   legend.text = element_text(family = "DIN-Regular"),
   legend.title = element_blank(),
   strip.text.x = element_text(size = 12, family = "DIN-Regular"),
   plot.subtitle = element_text(face = "italic", family = "Ropa Sans"),
   plot.caption = element_text(face = "italic", family = "Ropa Sans"),
   axis.text = element_text(family = "DIN-Bold"),
   axis.title = element_text(size = 12, family = "DIN-Regular"))

last_plot() + 
   dra_theme
```

    ## `geom_smooth()` using formula = 'y ~ x'
    ## `geom_smooth()` using formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

## Labeling

Sometimes it’s useful to label points to show their identities.
`geom_text` usually gives messy, overlapping text. Before we fix that,
notice a few other things I’m doing here.

- Because we are demonstrating labels, I wanted to narrow down the
  dataset, so I’m using tidyverse techniques like pipes and filter so
  that we are only looking at 2007, the most recent year available.
- Notice that because I’m using pipes, I don’t need to declare a dataset
  in the first ggplot statement. It inherits the previous data from the
  pipe.
- I’ve also added better x and y labels and a title through the use of
  the `labs` layer.

``` r
gapminder %>% 
   filter(year == max(year),
          continent == "Americas") %>% 
   ggplot(aes(gdpPercap, lifeExp)) +
   geom_point() +
   geom_text(aes(label = country)) +
   scale_x_log10() +
   geom_smooth() +
   labs(title = "Per Capita GDP by Life Expectancy in the Americas - 2007",
        x = "Per Capita GDP",
        y = "Life Expectancy")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

We still need to fixe that messy label text, but let’s make a few
improvements first:

- Change the labels on the X axis to better show that its a currency.
  I’m using the `scales` library here, which allows for commas,
  currency, percents, scientific notation, and others.
- Notice that I’m changing the accuracy to lose 2 decimal points,
  scaling the number by 1/1000 and then adding a suffix of “k” to it.
  The “dollar_format” argument gives me the \$.
- Let’s also add a subtitle and a caption. I’d make them something more
  original, but I’m at my daughter’s figure skating practice and its
  very cold, which makes it hard to be creative.

``` r
gapminder %>% 
   filter(year == max(year),
          continent == "Americas") %>% 
   ggplot(aes(gdpPercap, lifeExp)) +
   geom_point() +
   geom_text(aes(label = country)) +
   scale_x_log10(labels = scales::dollar_format(accuracy = 2, scale = 1/1000, suffix = "K")) +
   geom_smooth() +
   labs(title = "Per Capita GDP by Life Expectancy in the Americas - 2007",
        subtitle = "This is where the subtitle goes.",
        caption = "Here is the caption text.",
        x = "Per Capita GDP",
        y = "Life Expectancy")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

There are two ways we can deal with this messy text. First, we can use a
library called `ggrepel` which has an adapted text geom called
`geom_text_repel`. It repels overlapping text labels. Text labels repel
away from each other, away from data points, and away from edges of the
plotting area (panel).

``` r
gapminder %>% 
   filter(year == max(year),
          continent == "Americas") %>% 
   ggplot(aes(gdpPercap, lifeExp)) +
   geom_point() +
   ggrepel::geom_text_repel(aes(label = country)) +
   scale_x_log10() +
   geom_smooth() +
   labs(title = "Per Capita GDP by Life Expectancy in the Americas - 2007",
        x = "Per Capita GDP",
        y = "Life Expectancy")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

    ## Warning: ggrepel: 1 unlabeled data points (too many overlaps). Consider
    ## increasing max.overlaps

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

The other way to deal with too many labels is to filter your data. You
can label points selectively by using some criterion to assign labels to
points.

Here we create a loess model (which, remember is the statistical
transformation we get from geom_smooth)

Then we get the residuals of the model, followed by filtering the
dataset so we create a new var country_label that only shows up if it is
an outlier on the Loess model.

``` r
d1 <- gapminder %>% 
   filter(year == max(year),
          continent == "Americas")

model1 <- loess(lifeExp ~ gdpPercap, d1)
resids1 <- residuals(model1)

d1 <- d1 %>% 
   mutate(country_label = ifelse(abs(resids1) > 2.5, as.character(country), ""))

p2 <- ggplot(d1, aes(gdpPercap, lifeExp)) +
   geom_point() +
   ggrepel::geom_text_repel(aes(label = country_label)) +
   scale_x_log10() +
   geom_smooth() +
   labs(title = "Per Capita GDP by Life Expectancy in the Americas - 2007",
        x = "Per Capita GDP",
        y = "Life Expectancy")

p2
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

You can zoom in on your plots, but there are two very different ways to
do that. You can zoom and clip the data (essentially filter unseen data
out of the dataset), or you can zoom and NOT clip the data, it is more a
literal zoom in.

Let’s see how it works when we do not clip the data.

We call `coord_cartesian` and put in very high limits on both axes very
high, but it doesn’t get rid of the data. Notice how you can still see
some of the labels AND the trend line is unchanged from what we had in
the previous plot.

``` r
p2 + 
   coord_cartesian(xlim = c(10000, 50000), ylim = c(75, 85))
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

Now we DO clip (filter) the data:

``` r
p2 +
   xlim(10000, 50000) +
   ylim(75, 85)
```

    ## Scale for x is already present.
    ## Adding another scale for x, which will replace the existing scale.
    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

    ## Warning: Removed 18 rows containing non-finite values (`stat_smooth()`).

    ## Warning: Removed 18 rows containing missing values (`geom_point()`).

    ## Warning: Removed 18 rows containing missing values (`geom_text_repel()`).

    ## Warning: Removed 2 rows containing missing values (`geom_smooth()`).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning
    ## -Inf

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

- Here instead we call xlim and ylim (we could also have put “limits =”
  arguments into a `scale_x_continuous` function and
  `scale_y_continuous` function.
- Notice the warnings that tell us they removed data, and also notice
  how there is only one trend line, and not enough to give us a
  confidence interval.

## Pie Charts

Let’s make some pies. If you think about it, a pie chart is just a bar
chart in polar coordinates! So first, we have to make a bar chart. This
will be a simple count based chart (no percentages) just to keep things
less confusing for now.

``` r
pie1 <- gapminder %>% 
   filter(year == 2007,
          continent == "Americas") %>% 
   arrange(desc(pop)) %>% 
   top_n(5) %>%
   ggplot(aes(x = "", y = pop, fill = country)) +
   geom_bar(stat = "identity")
```

    ## Selecting by gdpPercap

``` r
pie1
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-38-1.png)<!-- -->

Now we simply take that bar chart and convert the coordinates to polar
using `coord_polar`. I’ve also added a `theme_void` call because without
it the default gives you some weird lines and shading.

``` r
pie1 +
   coord_polar("y", start = 0) + 
   theme_void()
```

![](ggplot2-Lecture_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

## Saving Plots

You’ll want to save your plots eventually.

- To save your most recent plot, just use `ggsave` with a path and
  filename

``` r
ggsave("~/Dropbox (Personal)/Teaching/PPOL 563/spring23_code/Week 3 - ggplot/plots/pop_top5_americas.png")
```

    ## Saving 7 x 5 in image

- If you have a plot object, name it as an argument to the `ggsave`
  function

``` r
ggsave("~/Dropbox (Personal)/Teaching/PPOL 563/spring23_code/Week 3 - ggplot/plots/test1.png", p2)
```

    ## Saving 7 x 5 in image
    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

- You can also specify the size it is saved in, indicating the height
  and width and the appropriate units ( options are “in”, “cm”, “mm”,
  “px”).

- You can also save it in a number of different formats (pdf, png, eps,
  svg, jpg, …)

``` r
ggsave("~/Dropbox (Personal)/Teaching/PPOL 563/spring23_code/Week 3 - ggplot/plots/test2.pdf", width = 8.5, height = 11, units = "in")
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
