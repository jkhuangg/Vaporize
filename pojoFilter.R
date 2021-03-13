library(stringr)
op=readLines("gbm_pojo_test.java")
x=1
np=c()
while (!is.na(op[x])) {
  if (str_detect(op[x], regex("^@ModelPojo")) |
      str_detect(op[x], regex(".*super.*(.*)")) |
      str_detect(op[x], regex("^import hex.*")) |
      str_detect(op[x], regex(".*getModelCategory.*"))
      ) 
  {
    x=x+1
    next
  }
  
  new_line=op[x]
  new_line=str_replace_all(new_line, fixed(" extends GenModel"), "")
  new_line=str_replace_all(new_line, fixed("hex.genmodel."), "")
  
  np=c(np, new_line)
  x=x+1
}

writeLines(np, "gbm_pojo_test.java")