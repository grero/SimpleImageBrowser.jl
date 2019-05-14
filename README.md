# Introduction
[![Build Status](https://travis-ci.org/grero/SimpleImageBrowser.jl.svg?branch=master)](https://travis-ci.org/grero/SimpleImageBrowser.jl)
[![Coverage Status](https://coveralls.io/repos/github/grero/SimpleImageBrowser.jl/badge.svg?branch=master)](https://coveralls.io/github/grero/SimpleImageBrowser.jl?branch=master)
A simple tool for creating a web page to browser a list of images

# Usage

To create a web page to display the two images apple.jpg and pear.jpg in the current directory, do

```julia
SimpleImageBrowser.generate_webpage(["apple.jpg", "pear.jpg"])
```

This will create app/index.html, app/images/apple.jpg and app/images/pear.jpg, which can then be uploaded to any webserver.
