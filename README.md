# CImGuiExtensions

[![Build Status](https://travis-ci.com/zygmuntszpak/CImGuiExtensions.jl.svg?branch=master)](https://travis-ci.com/zygmuntszpak/CImGuiExtensions.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/zygmuntszpak/CImGuiExtensions.jl?svg=true)](https://ci.appveyor.com/project/zygmuntszpak/CImGuiExtensions-jl)
[![Codecov](https://codecov.io/gh/zygmuntszpak/CImGuiExtensions.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/zygmuntszpak/CImGuiExtensions.jl)

This package provides additional widgets for the [CImGui](https://github.com/Gnimuc/CImGui.jl) package.
The development of the widgets is based on my Julia interpretation of Trygve Reenskaug's
[Data, Context and Interaction](https://klevas.mif.vu.lt/~donatas/Vadovavimas/Temos/DCI/2009%20The%20DCI%20Architecture%20-%20A%20New%20Vision%20of%20OOP.pdf) paradigm.

The package lays the foundations for several basic use-cases, such as loading and saving data.

I am in the process of writing several GUI applications and am continually refactoring code into this repository.
Because this package is currently under active development the API may continue to change.

## Examples
### File Dialog
![File Dialog Animation](examples/open_file_example.gif?raw=true)

### Label Interval Widget
![Label Interval Animation](examples/label_interval_example.gif?raw=true)
