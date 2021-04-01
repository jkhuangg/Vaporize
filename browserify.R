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
  system("sed -i \"/exports/d\" bundle.js")
  system("sed -i \"/require/d\" bundle.js")

  # BROWSERIFY
  system("sed -i \"/require/d\" gen_main.js")
  system("sed -i \"/require/d\" gen_html.js")
  system("mkdir browser")
  system("mv index.html browser/")
  system("mv bundle.js browser/")
}
