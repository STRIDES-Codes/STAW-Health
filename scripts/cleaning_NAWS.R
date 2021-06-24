#this script cleans and preps ag data from NAWS_A2E185.csv and NAWS_F2Y185.csv for our codeathon product
# these files are two halves of the same dataset - A2E is alphabetic variables A through E, F 2 Y is similarly done
# started by Lisa Mayer 6.22.21

install.packages("dplyr")
library(dplyr)

#import data from github
NAWS_A2E=read.csv("~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/NAWS/raw_data/NAWS_A2E185.csv")
NAWS_F2Y=read.csv("~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/NAWS/raw_data/NAWS_F2Y185.csv")

#merge to put all variables in the same place
NAWS_full=dplyr::left_join(NAWS_A2E,NAWS_F2Y, by="FWID")

#create character vector of variables of interest
keep_vars=c("FWID", #worker id
            "FY.x", #fiscal year
            "REGION6", #US region (6 possible)
            "MIGRANT", #respondent is a migrant worker
            "FAMPOV", #fam income below poverty level
            "FWWEEKS", #farm work wks in last 5 yrs
            "CROWDED1", #crowded by census def of >1 person per room
            "A21a", #health insurance status respondent
            "B01", #hispanic/latino categories
            "B02", #race
            "currstat", #legal status
            "AYUDAPUB", #public aid
            "B11", #reported yrs farmwork USA
            "NHaCondition", #declared at least one health condition
            "NQ10a", #difficulty health access transportation/distance
            "NQ10b", #diff hlth access don't know where to go
            "NQ10c", #health center not open when needed
            "NQ10d", #do not have service needed
            "NQ10e", #don't speak language
            "NQ10f", #don't feel welcome
            "NQ10g", #don't understand problems
            "NQ10h", #worried about losing job
            "NQ10i", #health care too expensive 
            "NQ10j", #other difficulty
            "NQ10l" #undocumented and docs don't treat us well
            )

#keep vars of interest
mini_NAWS=NAWS_full%>%
  select(any_of(keep_vars))

#double check vars brought in
#keep_vars[duplicated(keep_vars)] #check for dupes
#mini_cols=colnames(mini_NAWS) 
#setdiff(keep_vars,mini_cols) #check for missing

#restrict to last four years to match other data
#  keep FYs 2013, 2014, 2015, 2016
#rename variables; use DIFF vars to create single difficulty accessing medical care var
mini_NAWS=mini_NAWS%>%
  rename("FY"="FY.x",
         "INS_STAT"="A21a",
         "HISPCAT"="B01",
         "RACE"="B02",
         "DIFF_TRANSP"="NQ10a",
         "DIFF_DK"="NQ10b",
         "DIFF_NO"="NQ10c",
         "DIFF_SERV"="NQ10d",
         "DIFF_LANG"="NQ10e",
         "DIFF_WELC"="NQ10f",
         "DIFF_UNDER"="NQ10g",
         "DIFF_JOB"="NQ10h",
         "DIFF_EXP"="NQ10i",
         "DIFF_OTH"="NQ10j",
         "DIFF_UNDOC"="NQ10l",
         "YEARS"="B11"
         )%>%
  mutate(DIFFICULT=case_when(DIFF_TRANSP==1 | DIFF_DK==1 | DIFF_NO==1 | DIFF_SERV==1 
                              | DIFF_LANG==1 | DIFF_WELC==1 | DIFF_UNDER==1  
                               | DIFF_JOB==1 | DIFF_EXP==1 | DIFF_OTH==1 | DIFF_UNDOC==1 ~ 1,
                             
                             DIFF_TRANSP==0 | DIFF_DK==0 | DIFF_NO==0 | DIFF_SERV==0 
                              | DIFF_LANG==0 | DIFF_WELC==0 | DIFF_UNDER==0  
                               | DIFF_JOB==0 | DIFF_EXP==0 | DIFF_OTH==0 | DIFF_UNDOC==0 ~ 0,
                             
                             DIFF_TRANSP==7 | DIFF_DK==7 | DIFF_NO==7 | DIFF_SERV==7 
                              | DIFF_LANG==7 | DIFF_WELC==7 | DIFF_UNDER==7  
                               | DIFF_JOB==7 | DIFF_EXP==7 | DIFF_OTH==7 | DIFF_UNDOC==7 ~ NA_real_,
                             
                             TRUE ~ NA_real_
    
  ))%>%#7 corresponds to don't know, set as NA for this analysis
  filter(FY>=2013)

#drop original DIFF vars and make new binary vars for risk score
mini_NAWS=mini_NAWS%>%
  select(-c(DIFF_TRANSP,DIFF_DK,DIFF_NO,DIFF_SERV,DIFF_LANG,DIFF_WELC,DIFF_UNDER,
            DIFF_JOB,DIFF_EXP,DIFF_OTH,DIFF_UNDOC))%>%
  mutate(UNAUTH=case_when(currstat == 4 ~ 1,
                          currstat == 1 | currstat == 2 | currstat == 3 ~ 0,
                          TRUE ~ NA_real_
                          ),
         NOINS=case_when(INS_STAT==1 ~ 1,
                             INS_STAT==0 ~ 0,
                             TRUE ~ NA_real_
         ))

#make risk score variable as simple sum of risk vars
# range 0 to 7, where 7 is highest risk
mini_NAWS=mini_NAWS%>%
  rowwise()%>%
  mutate(RISK=sum(MIGRANT, 
                  FAMPOV,
                  CROWDED1,
                  NOINS,
                  UNAUTH,
                  AYUDAPUB,
                  NHaCondition,
                  DIFFICULT)
  )


#calculate average score by region, count number of workers in each region
region_NAWS=mini_NAWS%>%
  group_by(REGION6,FY)%>%
  mutate(MEAN_RISK=mean(RISK, na.rm=T),
         NUM_WORKERS=n_distinct(FWID))%>%
  select(c(REGION6,FY,MEAN_RISK,NUM_WORKERS))

#remove duplicate rows
final_NAWS=region_NAWS[!duplicated(region_NAWS), ]

#save dataset
write.csv(final_NAWS,"~/Spatial-forecasting-of-environmental-infectious-diseases-within-vulnerable-populations/data/NAWS/final_NAWS.csv")

