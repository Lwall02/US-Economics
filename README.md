# Economic Effect on Investor Confidence

## Overview

This repo contains the `R` scripts, `PDF` report and code, and `data` used to complete a thorough analysis of economic factors and their effect on the one-year confidence index released by ICF. This report looks into the relationships of economic factors like GDP, unemployment rate, the VIX, and others in order to try and predict the one-year confidence index in the market. The question this paper tries to answer is can we predict investor confidence based on the market. 


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from the ICF and FRED API.
-   `data/analysis_data` contains the cleaned dataset that was constructed. Saved as a parquet.
-   `model` contains the fitted model used in the paper. 
-   `other` contains relevant details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of this paper were written with the help of OpenAI's ChatGPT. In regards to the text in this paper, ChatGPT was used for advice, wording help, and grammar/spelling correction. In regards to the code for this paper, ChatGPT was used in making simulation data and help with formulating tests, as well as parts of the graphs and figures in the report. Lastly, ChatGPT was used help with rendering and code errors. 