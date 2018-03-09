# World Happiness Report Analysis

Summary
An analysis of World Happiness Report has been conducted using an open source data-set. The objective of the project includes studying the various factors which lead up to the calculation of a “Happiness Index” for each country and understanding its distribution throughout the world. 
The process involves ingesting the data-set in SQL, cleaning the dataset and then using it in R through RODBC server. Further, a regression model and clustering analysis has been done in R. Finally, the data has been visualized through Tableau in which the data has been imported from Microsoft SQL Server using the SQL server connection.
Data Overview
Source: The dataset is an open source dataset from a report published on world happiness, first in 2012 and thereafter every year. This report is an outcome of the survey results of Gallup World Poll which takes representative sample from each country and asks them questions in the form of Cantril ladder, which is asking respondents to think of a ladder with the best possible life for them being a 10 and the worst possible life being a 0 and to rate their own current lives on that scale. 
The dataset is present here for 2015-2017 : https://www.kaggle.com/unsdsn/world-happiness/data
Data Description:
The datasets are identical except for the year they contain information of and have the following columns:
•	Country: Name of the country
•	Region: Region of the world, the country belongs to
•	Happiness Rank: Rank of the country according to happiness score
•	Happiness Score: Metric measured as a combination of various factors
•	Economy (GDP per capita): The extent to which GDP contributes to happiness
•	Family: The extent to which Family contributes to happiness
•	Health (Life Expectancy): The extent to which Life Expectancy contributes to happiness
•	Freedom: The extent to which Freedom contributes to happiness
•	Trust (Government Corruption): The extent to which trust in government contributes to happiness
•	Generosity: Generosity of the general public and its contribution to happiness
•	Dystopia Residual: Contribution to Dystopia residual to happiness. Dystopia is an imaginary country that has the world’s least happy people. The purpose of having this is to have a lower benchmark so that all countries do positively against it. This variable has no physical significance.
