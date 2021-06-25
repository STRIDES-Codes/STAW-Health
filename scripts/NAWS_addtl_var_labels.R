#code pieces for additional variables of interest in NAWS in case we care about them later
#superceded by shorter list - not used; rename with labels at the end of script
keep_vars_long=c("FWID", #worker id
                 "FY.x", #fiscal year
                 "PWTYCRD.x", #weights (all years)
                 "REGION6", #US region (6 possible)
                 "AGE", #respondent age
                 "GENDER", #respondent gender
                 "MIGRANT", #respondent is a migrant worker
                 "FAMPOV", #fam income below poverty level
                 "NUMYRSFW", #yrs since first farm job
                 "FWWEEKS", #farm work wks in last 5 yrs
                 "CROWDED1", #crowded by census def of >1 person per room
                 "CROWDED2", #crowded by HUD def ratio persons per room not to exceed 2
                 "PESTCONT", #mixed or applied pesticides in last yr
                 "A21a", #health insurance status respondent
                 "B01", #hispanic/latino categories
                 "B02", #race
                 "G01", #personal income - categorical w/ many options
                 "G03", #family income - categorical w/ many options
                 "FWWEEKS", #farm work wks
                 "TASK", #task code
                 "AYUDAPUB", #public aid
                 "currstat", #legal status
                 "legappl", #legal application status
                 "A07", #birth country
                 "A09", #highest level of education
                 "FOREIGNB", #binary foreign born
                 "B07", #how well do you speak English
                 "B08", #how well do you read English
                 "B11", #reported yrs farmwork USA
                 "G04B", #food stamp use
                 "G04C", #disability insurance use
                 "G04D", #unemployment insurance use
                 "G04E", #social security use
                 "G04F", #veterans pay
                 "G04G", #general assistance/welfare use
                 "G04H", #low inc housing
                 "G04I", #gov pub health clinic
                 "G04J", #medicaid
                 "G04K", #WIC use
                 "G04L", #disaster relief use
                 "G04M", #legal aid use
                 "G04N", #other social service use
                 "G04P", #temporary assistance for needy families (TANF)
                 "NH01", #asthma ever
                 "NH02", #diabetes ever
                 "NH03", #high blood pressure
                 "NH04", #TB ever
                 "NH05", #heart disease ever
                 "NH06", #UTI ever
                 "NH10", #other health condition
                 "NHaCondition", #declared at least one health condition
                 "NP01f", #pest control last yr
                 "NQ01", #health services last 2 yrs in US
                 "NQ01a", #health services last 2 yrs outside US
                 "NQ03b", #type of health service
                 "NQ05", #who paid health service
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
                 "NQ10l", #undocumented and docs don't treat us well
                 "NQ10m", #never needed healthcare
                 "NS01", #does employer provide clean water and cups?
                 "NS04", #does employer provide toilet?
                 "NS09" #does employer provide water to wash hands?
)



#old rename in case we want original vars
rename("FY"="FY.x",
       "PWTYCRD"= "PWTYCRD.x",
       "INS_STAT"="A21a",
       "HISPCAT"="B01",
       "RACE"="B02",
       "PERS_INCOME"="G01",
       "FAM_INCOME"="G03",
       "EDUCAT"="A09",
       "COUNTRY_BIRTH"="A07",
       "STAMPS"="G04B",
       "DISAB"="G04C",
       "UNEMP"="G04D",
       "SOCSEC"="G04E",
       "VETPAY"="G04F",
       "GENASS"="G04G",
       "LOHOUSE"="G04H",
       "PUBCLINIC"="G04I",
       "MEDICAID"="G04J",
       "WIC"="G04K",
       "DISRELIEF"="G04L",
       "LEGALAID"="G04M",
       "OTHSERV"="G04N",
       "TANF"="G04P", 
       "ASTHMA"="NH01",
       "DIABETES"="NH02",
       "HIBP"="NH03",
       "TB"="NH04",
       "HEARTDIS"="NH05",
       "UTI"="NH06",
       "OTH_HLTH"="NH10",
       "CHEMLASTYR"="NP01f",
       "HLTHSRV_US"="NQ01",
       "HLTHSRV_OTH"="NQ01a",
       "MED_TYPE"="NQ03b",
       "MED_PAID"="NQ05",
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
       "DIFF_NONEED"="NQ10m",
       "WATER"="NS01",
       "TOILET"="NS04",
       "WASH"="NS09")