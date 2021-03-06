#############  RUN THE NELSON FMS MODEL / MERGE RESULTS

### Select wd based on source of files
 ## Read-in prepared txt files (see R_nelson_files script)
 files = list.files("/home/wpage/Documents/ASOS/nelson_fms/forecast")

 input.loc = grep("input",files)
 
 ## Run the Nelson dfm program / Start for loop for each input file
 for (i in 1:length(input.loc)) { 
  # Get input file name
  input = files[input.loc[i]] 
  
  # Make output file name (just to make sure)
  out.name = unlist(strsplit(input,"[_]"))
  out = paste(out.name[1],"_",out.name[2],"_","out.txt",sep="")

  # Build call
  changedir = "cd /home/wpage/Documents/firewx-evaluation/build_fms && "
  dfm = paste(changedir,"./compute_dfm ","--input_file ",input,
  " --output_file ",out,sep="")

  # Run the program
  run = system(dfm)   }

 ## Extract output from Nelson / Save output
 dir = "/home/wpage/Documents/ASOS/nelson_fms/forecast/"
 out.loc = grep("out",files)
 dead.fms = data.frame()
 for (i in 1:length(out.loc)) {
  output = files[out.loc[i]]
  out.name = unlist(strsplit(output,"[_]"))[1]
  fms = read.csv(paste(dir,output,sep=""),header=TRUE)
  fms$datetime = paste(fms$month,"/",fms$day,"/",fms$year," ",fms$hour,":","00",sep="")
  fms$station_id = out.name
  drops = c("year","month","day","hour")
  fms = fms[,!(names(fms) %in% drops)]
  dead.fms = rbind(fms,dead.fms) }
 
 ## Save the output for later
 write.csv(dead.fms,file="/home/wpage/Documents/ASOS/nelson_fms/forecast/deadfms_asos_pred.csv")


 
