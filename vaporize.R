source("evaporate.R")
source("browserify.R")

vaporize <- function(pojo) {
  
  # TURN POJO INTO JAVASCRIPT FILE
  js_file=evaporate(pojo)
  print(paste(pojo, "has been transpiled into", js_file))
  
  # SANITY CHECK: DOES JS_FILE EXIST? 
  if (!file.exists(js_file))
    stop(paste(js_file, "not present. Abort."))
  
  # TURN JAVASCRIPT FILE INTO HTML
  browserify(js_file)
  print("all necessary files have been created in browser/ folder")
  
}

vaporize("gbm_pojo_test.java")