library(stringr)

# LEFT-OVER JAVA FROM JSWEET
# TO BE CONTINUE...
java_array='new java.util.ArrayList()'
java_doubleToBits='javaemul.internal.DoubleHelper.doubleToRawLongBits(d)'
java_NaN='javaemul.internal.DoubleHelper.NaN'
jvsc_doubleToBits='(function (f) { var buf = new ArrayBuffer(4); (new Float32Array(buf))[0] = f; return (new Uint32Array(buf))[0]; })(Math.fround(d))'
java_arrFill='java.util.Arrays.fill(preds, 0);'

jsweet_filter <- function(jsweet_file) {
  # GET CLASS
  # if user passes in path to file like path/to/jsweet.js
  # this will just return 'jsweet' to js_class
  js_class=str_extract(jsweet_file, regex('([^/]+)(?=\\.[^.]+)'))

  # READ IN JSWEET FILE
  ojs=readLines(jsweet_file)
  fjs=c()
  
  x=1
  while (!is.na(ojs[x])) {
    new_line=ojs[x]
    new_line=str_replace_all(new_line, fixed(java_array), fixed("[]"))
    new_line=str_replace_all(new_line, fixed(java_doubleToBits), fixed(jvsc_doubleToBits))
    new_line=str_replace_all(new_line, fixed(".add"), fixed(".push"))
    new_line=str_replace_all(new_line, fixed(java_NaN), fixed("NaN"))
    new_line=str_replace_all(new_line, fixed(java_arrFill), fixed("preds.fill(0);"))
  
    fjs=c(fjs, new_line)
    x=x+1
  }
  
  writeLines(fjs, jsweet_file)
  write(paste0("exports.",js_class,"=",js_class,";"),
        file=jsweet_file,
        append=TRUE)
} 

