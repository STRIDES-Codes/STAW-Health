# Environmental infectious disease risk in agricultural workers


This project was part of the [June 2021 Health Disparities Codeathon run by the Office of Data Science Strategy at NIH and Howard University](https://datascience.nih.gov/participant-application-health-disparities-codeathon)


# What are environmental infectious diseases?

We use this term to include any infectious disease that has an environmental component in transmission. This could include mosquito-borne, tick-borne, fungal, zoonotic, waterborne, and soil-based diseases. Our initial tool will focus on Lyme, Cryptosporidosis ("Crypto"), Dengue, and Campylobacteriosis ("Camp").

# What is the problem?

Environmental infectious diseases have significant mortality and morbidity and are expected to increase with climate change. This burden falls more on certain groups than others, and not everyone is equally equipped to mitigate their risk. One such group is agricultural workers who have risk factors such as environmental exposures (temperature, precipitation, etc.), access to healthcare, living in crowded housing, income and socioeconomic status, and various others.

Occupational health risk to agricultural workers in the United States has not been fully assessed. Existing research is limited to small groups, narrow data scope, or is outside of the United States. 

# Why should we solve it?

Accurately evaluating risk would illustrate the issue, encourage further research, and support interventions or policy protecting workers. This will become increasingly important as risk changes with climate.

# How are we going address this problem?

This project will begin to fill the research gap by integrating data sources and creating a web app with R shiny to visualize risk. This visualization tool will be shared with anyone who may benefit; from farm workers themselves to health departments to policymakers. We hope that this analysis will bring attention to the issue, ultimately inspiring interventions to protect agricultural workers in the face of increasing risks.

The workflow overview below shows where we got data and how it was processed to create our Shiny app.

![Workflow diagram](Workflow_disparities_codeathon.png)


# The Team, the team, the team:

Emerging Leaders in Data Science Fellows (ELFs),
Office of Data Science and Emerging Technologies (ODSET),National Institute of Allergies and Infectious Diseases (NIAID), National Institutes of Health (NIH)

Sydney Foote, Team Lead 🌞  
Mark Rustad, Sysadmin 🤘  
Lisa Mayer, Writer  
Meg Hartwick, Float   
Sara Jones, Float :smile_cat:


# How to use the Shiny app

## Access the app:

Text about getting to the app will go here. 

## Interact with the app:

1. This will be the first thing you see when you open the app.
2. This will be the second thing you should do when you get into the app.
3. etc.

## Troubleshooting

Add advice here if needed.


# Data sources and analysis

## National Agricultural Workers Survey (NAWS)

This survey is conducted by ---- and is designed to assess ----. We used data from years XXXX to XXXX and extracted variables describing ----. These can be seen in summary/codebook here-.

## CDC National Notifiable Diseases Surveillance System (NNDSS)

This is a repository of data reported by states for notifiable diseases maintained by the US CDC. We extracted yearly summary data from 2014-2017 using their built-in API for the diseases of interest (Lyme, Cryptosporidosis ("Crypto"), Dengue, and Campylobacteriosis ("Camp")).

## National Oceanic and Atmospheric Administration (NOAA)

This dataset includes various climate measures. We extracted ---- due to their link with the environmental diseases off interest.

## Intermediate datasets
Here we'll write some stuff about our intermediate data.

## Building the Shiny app
Here we'll write some stuff about coding the app.

# Additional Functionality
If our app does anything else, we can talk about it here.

# Future Functionality
This is where we'll put stuff we want our app to do someday.
