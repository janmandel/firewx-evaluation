#############  Merge Final Database

### Start with ASOS data
 ## Set Working Directory
 setwd("/media/wpage/Elements/Page/NDFD_Project/Weather/ASOS")
 
 ## Read-in data
 asos.data = read.csv("asos_final3.csv",stringsAsFactors=FALSE)
 asos.data$X100hrfm = as.numeric(asos.data$X100hrfm)
 asos.data = asos.data[c("station_id","station_type","data_type","lon","lat","datetime",
 "air_temp_c","rh","wind_speed20ft_mps","wind_speedMid_mps","wind_direction_deg",
"cloud_cover_percent","precip_mm","solar_wm2","FM40","asp_deg","elev_m","slope_deg",
 "CBD_kgm3","CBH_m","CC_percent","CH_m","X1hrfm","X10hrfm","X100hrfm",
 "LiveHerb_frac_percent","LiveWood_frac_percent","ROS_mps","flame_length_m")]

### Bring in RAWS data
 ## Set Working Directory
 setwd("/media/wpage/Elements/Page/NDFD_Project/Weather/RAWS")
 
 ## Read-in data
 merge.raws = read.csv("asos_final3.csv",stringsAsFactors=FALSE)
 merge.raws$X = NULL
 merge.raws$X100hrfm = as.numeric(merge.raws$X100hrfm)

### Union two databases
setwd("/media/wpage/Elements/Page/NDFD_Project/Weather")
library(RSQLite)
 db = dbConnect(SQLite(),dbname="final.sqlite")
 dbWriteTable(db,"raws",merge.raws,row.names=FALSE) 
 dbWriteTable(db,"asos",asos.data,row.names=FALSE)
 final = dbGetQuery(db,"SELECT * FROM raws UNION SELECT * FROM asos")
 dbWriteTable(db,"final",final,row.names=FALSE)
 dbDisconnect(db)

 ## Save final database
 library(data.table)
 setwd("/media/wpage/Elements/Page/NDFD_Project/Weather")
 fwrite(final,"final.csv")
 

