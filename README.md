## READ ME
# STAT3 Protein Changes Visualization

[![Shiny](https://img.shields.io/badge/Shiny-1.7.4-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://shiny.rstudio.com/)
[![g3viz](https://img.shields.io/badge/g3viz-1.1.5-orange?style=flat&labelColor=white)](https://github.com/G3viz/g3viz)

An interactive web application to visualize STAT3 protein changes across different diseases using a lollipop diagram.

## Features

- Interactive lollipop plot for STAT3 protein changes
- Filter data by disease type
- Multiple disease selection option
- Downloadable filtered data
- Interactive data table view
- Built-in tutorial for easy navigation

## Installation

### Prerequisites

Ensure you have R installed on your system. This app has been tested with R version 4.1.0 or higher.

### Install required packages

Run the following commands in R to install the necessary packages:

```r
install.packages(c("shiny", "dplyr", "shinythemes", "shinycssloaders", "DT"))

# Install g3viz from GitHub
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("g3viz/g3viz")
