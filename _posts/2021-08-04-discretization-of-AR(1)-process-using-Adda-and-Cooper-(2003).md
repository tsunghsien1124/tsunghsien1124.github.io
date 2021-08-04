---
layout: "post"
title: "Discretization of AR(1) Process Using Adda and Copper (2003)"
permalink: "/Computation/:title/"
---


Discretization plays a necessary role.
There are multiple widely used approaches, including Tauchen, Rouwenhorst, and **Adda and Cooper (2003)**[^1] (hereafter, AC2003).
Package `QuantEcon` in `Julia` contains the former two; yet, I cannot find a decent implementation for the last one in `Julia`.
Hence, this blog aims to fill this void.
In the following, I will firstly explain how AC2003 works and then show how it can be implemented in `Julia`.

#### How AC(2003) Works

Still not sure if the page can be generated using a given layout.

#### Implementation in `Julia`

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



[^1]: Adda, J. and R. W. Cooper (2003), *"Dynamic Economics: Quantitative Methods and Applications"*, MIT Press.
