browserify <- function(js_file) {
  
  # EXTRACT CLASS NAME
  js_class=str_extract(js_file, regex('([^/]+)(?=\\.[^.]+)'))
  
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
  m=c(imp, f)
  writeLines(m, "main.js")
  writeLines(h, "index.html")
  
  # CALLS TO BROWSERIFY
  system("browserify --debug main.js -o bundle.js")
  system("sed -i \"/require/d\" gen_main.js")
  system("sed -i \"/require/d\" gen_html.js")
  system("mkdir browser")
  system("mv index.html browser/")
  system("mv main.js browser/")
  system("mv bundle.js browser/")
}

