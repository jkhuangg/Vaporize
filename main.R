source("pojoFilter.R")
source("jsweetFilter.R")

evaporate <- function(pojo) {
  # Get name of file when it is in JavaScript
  jsOut=paste0(str_extract(pojo, regex('([^/]+)(?=\\.[^.]+)')),".js")
  
  # Filter out POJO to make it H2O-independent
  pojo_filter(pojo)
  
  # bash commands to prepare & call JSweet
  system("rm src/main/java/*")
  system(paste("cp", pojo, "src/main/java"))
  system("cp GenMod/GenModel.java src/main/java")
  system("mvn generate-sources")
  system("mv target/js/bundle.js .")
  system(paste("mv bundle.js", jsOut))
  system("rm -rf target/")
  system("rm -r src/main/java/*")
  
  # Finally, round out left-over java syntax from JSweet
  jsweet_filter(jsOut)
  print(paste(pojo, "has now been transpiled into", jsOut))
}
  
evaporate("gbm_pojo_test.java")
