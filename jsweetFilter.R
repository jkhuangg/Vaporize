library(stringr)
# LEFT-OVER JAVA FROM JSWEET
java_array='new java.util.ArrayList()'
java_doubleToBits='javaemul.internal.DoubleHelper.doubleToRawLongBits(d)'
java_NaN='javaemul.internal.DoubleHelper.NaN'
jvsc_doubleToBits='(function (f) { var buf = new ArrayBuffer(4); (new Float32Array(buf))[0] = f; return (new Uint32Array(buf))[0]; })(Math.fround(d))'
java_arrFill='java.util.Arrays.fill(preds, 0);'

# BEGIN WRITING
ojs=readLines("gbm_pojo_test.js")
x=1
fjs=c()
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

writeLines(fjs, "gbm_pojo_test.js")