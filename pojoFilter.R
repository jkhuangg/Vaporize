library(stringr)

pojo_filter <- function(pojo_file) {
  # READ IN POJO FILE
  op=readLines(pojo_file)
  np=c()
  
  x=1
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
  
  writeLines(np, pojo_file)
}
