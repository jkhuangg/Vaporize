sed_filter <- function(file, exclude_term) {
  
  op=readLines(file)
  np=c()
  
  x=1
  while (!is.na(op[x])) {
    if (str_detect(op[x], exclude_term)) {
      x=x+1
      next
    }
    
    new_line=op[x]
    np=c(np, new_line)
    x=x+1
  }
  
  writeLines(np, file)
}



browserify <- function(js_file) {
  bund=any(str_detect(readLines("pom.xml"), "<bundle>true</bundle>"))
  # EXTRACT CLASS NAME
  js_class=str_extract(js_file, regex('([^/]+)(?=\\.[^.]+)'))
  js_txt=readLines(js_file)
  
  # PREPEND LINE OF CODE TO USE CLASS IN JAVASCRIPT
  imp=paste0("const {", js_class, "}=require(\"./", js_class, ".js\"); let m=new ", js_class, "(); let n=", js_class, ".NAMES_$LI$();")
  gen_main=readLines("gen_main.js")
  gen_html=readLines("gen_html.js")
  main_txt=c(imp, gen_main)
  html_txt=c(imp, gen_html)
  
  # GENERATE THE MAIN.JS AND INDEX.HTML
  writeLines(main_txt, "gen_main.js")
  writeLines(html_txt, "gen_html.js")
  f=system("node gen_main.js", intern=TRUE)
  h=system("node gen_html.js", intern=TRUE)
  m=c("", paste0("let m=new ", js_class, "()"), f)
  
  # BUNDLE
  if (!bund) {
    gm=readLines("GenModel.js")
    write(gm, "bundle.js")
  }
  write(js_txt, "bundle.js", append=TRUE)
  write(m, "bundle.js", append=TRUE)
  write(h, "index.html")
  
  # FILTER NODE REQUIREMENTS
  sed_filter("bundle.js", "exports")
  sed_filter("bundle.js", "require")
  sed_filter("gen_html.js", "require")
  sed_filter("gen_main.js", "require")

  # BROWSERIFY
  dir.create("browser")
  file.rename(from="index.html", to="browser/index.html")
  file.rename(from="bundle.js" , to="browser/bundle.js")
}
