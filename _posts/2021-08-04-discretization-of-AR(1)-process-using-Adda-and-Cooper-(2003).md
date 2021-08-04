---
layout: "post"
title: "Discretization of AR(1) Process Using Adda and Copper (2003)"
permalink: "/Computation/:title/"
---


Discretization plays a necessary role in computation. There are a number of common approaches, including Tauchen, Rouwenhorst, and **Adda and Cooper (2003)**.

#### How It Works

Still not sure if the page can be generated using a given layout.

#### Test Math Display

Define a function $f(x) = x^2$ as follows.




Such function evaluated at 2 is given by $f(2) = 4$.

\\[\log(2) + 5y = \int_0^\infty \frac{1}{z} \, dz\\]

#### Test Plot.jl

Load Plots.jl

```julia
using Plots
```




Plot a figure with randomly generated data.

```julia
N = 100
x = rand(N)
y = rand(N)
plot(x, y)
```

![](/assets/figures/2021-08-04-discretization-of-AR(1)-process-using-Adda-and-Cooper-(2003)_3_1.png)
