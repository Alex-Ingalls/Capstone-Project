import pandas as pd

GHCNTemp = "C:\\Users\\alexi\\Dropbox\\Undergrad_Coursework\\COS 470\\Capstone-Project\\clean-data\\GHCNTemp.csv"
SNOWTemp = "C:\\Users\\alexi\\Dropbox\\Undergrad_Coursework\\COS 470\\Capstone-Project\\clean-data\\SNOWTemp.csv"

GHCN = pd.read_csv(GHCNTemp)
SNOW = pd.read_csv(SNOWTemp)

precisionLimit = 0.035

for i in range(len(GHCN)):
  print(i)
  GLAT = GHCN.iloc[i,3]
  GLON = GHCN.iloc[i,4]
  for j in range(len(SNOW)):
    SLAT = SNOW.iloc[j,8]
    SLON = SNOW.iloc[j,9]
    if(GHCN.iloc[i,6] == SNOW.iloc[j,4]):
      if(GLAT <= (SLAT+precisionLimit)) & (GLAT >= (SLAT-precisionLimit)):
        if(GLON <= (SLON+precisionLimit)) & (GLON >= (SLON-precisionLimit)):
          GHCN.iloc[i,17] = SNOW.iloc[j,5]
          GHCN.iloc[i,18] = SNOW.iloc[j,6]
          GHCN.iloc[i,19] = SNOW.iloc[j,7]
          print(GHCN.iloc[i])
