source("pojoFilter.R")
source("jsweetFilter.R")

library(stringr)

evaporate <- function(pojo) {
  # First, check if the bundle option is set to true
  bund=any(str_detect(readLines("pom.xml"), "<bundle>true</bundle>"))
  
  # Second, check if src/main/java directory exists; if not, create them
  if (!dir.exists("src/main/java")) {
    dir.create("src")
    dir.create("src/main")
    dir.create("src/main/java")
  } else {
    unlink("src/main/java/*")
  }
  
  # Get name of file when it is in JavaScript
  jsOut=paste0(str_extract(pojo, regex('([^/]+)(?=\\.[^.]+)')),".js")
  
  # Filter out POJO to make it H2O-independent
  pojo_filter(pojo)
  
  # bash commands to prepare & call JSweet
  file.copy(pojo, "src/main/java")
  file.copy("GenMod/GenModel.java", "src/main/java")
  
  # call jsweet
  system("mvn generate-sources")
  
  if (bund) {
    if (file.exists("target/js/bundle.js")) {
      file.rename(from="target/js/bundle.js", to=jsOut)
    } else {
      print("Maven did not compiled correctly")
    }
  } else {
    system("mv target/js/* .")
  }
  
  # clean up
  unlink("target", recursive=TRUE)
  unlink("src/main/java/*")
  
  # Finally, round out left-over java syntax from JSweet
  jsweet_filter(jsOut)
  
  # IF bundle option is not select, we will need to import the 
  # GenModel class manually
  if (!bund) {
    if (file.exists("GenModel.js")) {
      jsweet_filter("GenModel.js")
      x=c("const {GenModel}=require(\"./GenModel\");", readLines(jsOut))
      write(x, file=jsOut)
    } else {
      print("something is wrong, you didn't choose the bundle option but the GenModel.js file isn't present")
    }
  }
  
  return(jsOut)
}
