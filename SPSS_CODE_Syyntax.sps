* Encoding: UTF-8.
t* Encoding: UTF-8.

des z1 z2 z3 z4 z5 z6 z7 z8 z9 z10.
temporary.
select if (sample=0).
FACTOR
  /VARIABLES z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
  /MISSING LISTWISE 
  /ANALYSIS z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(1) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.
compute sca1=means(z1 to z10).
variable labels sca1 'Resilience'.
des sca1.

RELIABILITY
  /VARIABLES=z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

des y1 to y22.

temporary.
select if (sample=0).
FACTOR
  /VARIABLES  y1 y2  y4 y5 y6 y7 y8  y10 y11  y13 y14 y15 y16 y17 y18 y19 y20  y21 y22
  /MISSING LISTWISE 
  /ANALYSIS y1 y2  y4 y5 y6 y7 y8  y10 y11  y13 y14 y15 y16 y17 y18 y19 y20  y21 y22
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(3) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.

temporary.
select if (sample=0).
FACTOR
  /VARIABLES     y4 y5 y6  y8  y10 y11  y13 y14 y15 y16 y17 y18 y19 y20  y21 y22
  /MISSING LISTWISE 
  /ANALYSIS    y4 y5 y6  y8  y10 y11  y13 y14 y15 y16 y17 y18 y19 y20  y21 y22
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(3) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.






RELIABILITY
  /VARIABLES=y11,y10,y6,y14,y5,y4,y13,y21,y8
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca2_1=means(y11,y10,y6,y14,y5,y4,y13,y21,y8).
variable labels sca2_1 'quality of life -Functioning'.
des sca2_1.


fre y16,y17,y18,y15.
RELIABILITY
  /VARIABLES=y16,y17,y18,y15
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca2_2=means(y16,y17,y18,y15).
variable labels sca2_2 'quality of life  תחושות שליליות competence'.
*compute sca2_2=1-sca2_2.
des sca2_2.

means sca2_2 by sex.


RELIABILITY
  /VARIABLES=y19,y20,y22
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca2_3=means(y19,y20,y22).
variable labels sca2_3 'quality of life - Positive feeling'.
des sca2_3.


CORRELATIONS
  /VARIABLES=sca2_1 sca2_2 sca2_3 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=sca4_1 sca4_2 with sca2_1 sca2_2 sca2_3 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=sca2_1 sca2_2 sca2_3 with sca1
  /PRINT=TWOTAIL NOSIG FULL
/MISSING=PAIRWISE.





temporary.
select if (sample=0).
FACTOR
  /VARIABLES  w1 w2 w3 w4 w5 w6
  /MISSING LISTWISE 
  /ANALYSIS w1 w2 w3 w4 w5 w6
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(1) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.
compute sca3=means(w1 to w6).
variable labels sca3 'Unware phone usage'.
des sca3.

RELIABILITY
  /VARIABLES=w1 w2 w3 w4 w5 w6
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

CORRELATIONS
  /VARIABLES=sca1 sca2_1 sca2_2 sca2_3 with sca3
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



des x1 to x17.


temporary.
select if (sample=0).
FACTOR
  /VARIABLES  x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17
  /MISSING LISTWISE 
  /ANALYSIS x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(4) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.


temporary.
select if (sample=0).
FACTOR
  /VARIABLES  x1 x2  x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17
  /MISSING LISTWISE 
  /ANALYSIS x1 x2  x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(2) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.


temporary.
select if (sample=0).
FACTOR
  /VARIABLES  x1 x2   x5 x6 x7 x10  x12 x16 x13
  /MISSING LISTWISE 
  /ANALYSIS x1 x2   x5 x6 x7 x10  x12 x16  x13
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(2) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.








RELIABILITY
  /VARIABLES=x1,x12,x5,x10,x16 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca4_1=means(x1,x12,x5,x10,x16).
variable labels sca4_1 'digital news צריכת חדשות דרך פלטפורמות חברתיות'.
des sca4_1.

RELIABILITY
  /VARIABLES=x2,x7,x6
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca4_2=means(x2,x7,x6).
variable labels sca4_2 'Traditional news צריכת חדשות דרך עיתונות רדיו וטלפויזיה'.
des sca4_2.



CORRELATIONS
  /VARIABLES=sca1 sca2_1 sca2_2 sca3 with sca4_1 sca4_2
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

fre age
gender
status
education.

recode gender (0=0)(0.5=1)(else=sysmis) into sex.
value labels sex 
0'male'
1'female'.
fre sex.

t-test groups=sex(0,1)/variables=sca1 sca2_1 sca2_2 sca2_2 sca2_3 sca3  sca4_1 sca4_2


CORRELATIONS
  /VARIABLES=sca1 sca2_1 sca2_2 sca3 sca4_1 sca4_2 with age  education 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=u1 to u9 with sca1 sca2_1 sca2_2 sca3 sca4_1 sca4_2
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=sca1 sca2_1 sca2_2 sca2_3 sca3 sca4_1 sca4_2
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

t-test groups=status(0,1)/variables=sca1 sca2_1 sca2_2 sca3  sca4_1 sca4_2

fre u1
u2
u3
u4
u5
u6
u7
u8
u9.

fre u1_1
u1_2
u1_3
u1_4
u1_5
u1_6
u1_7.
count nu1=u1_1
u1_2
u1_3
u1_4
u1_5
u1_6
u1_7 (1).
fre nu1.


if (u1_1=1) uu1=1.
if (u1_2=1) uu1=2.
if (u1_3=1) uu1=3.
if (u1_4=1) uu1=4.
if (u1_5=1) uu1=5.
if (u1_6=1) uu1=6.
if (u1_7=1) uu1=7.
value labels  uu1
    1'בחל"ת'
    2'גמלאי'
    3'מובטל'
    4'משרה חלקית'
    5'משרה מלאה'
    6'סטודנט'
    7'עצמאי'.


variable labels uu1 'תעסוקה'.

fre uu1.


UNIANOVA sca1  sca2_1 sca2_2 sca3  sca4_1 sca4_2 BY uu1
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(uu1) COMPARE ADJ(BONFERRONI)
  /PRINT ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=uu1.

fre v1
v2
v3
v4
v1_1
v1_2
v1_3
v4_1
v4_2
v4_3.


variable labels vv1 'דתיות'.
if (v1_1=1) vv1=1.
if (v1_2=1) vv1=2.
if (v1_3=1) vv1=3.
value labels vv1
    1'דתי'
    2'חילוני'
    3'מסורתי'.
fre vv1.

UNIANOVA sca1  sca2_1 sca2_2 sca3  sca4_1 sca4_2 BY vv1
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(vv1) COMPARE ADJ(BONFERRONI)
  /PRINT ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=vv1.






CORRELATIONS
  /VARIABLES=sca1 sca2_1 sca2_2 sca2_3 sca3 sca4_1 sca4_2  sca5
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.






CORRELATIONS
  /VARIABLES=sca4_1 sca4_2   x1 to x17 with 
  sca1 sca3 sca5 sca2_1 sca2_2 sca2_3 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.






CORRELATIONS
  /VARIABLES=v1 v2 v3 v4
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



fre u1 to u9.

CORRELATIONS
  /VARIABLES=
  u1 to u9
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


fre age
sex
status
education
sex
uu1
vv1.


des sca1  sca2_1 sca2_2 sca3  sca4_1 sca4_2. 

recode vv1 (1=3)(3=2)(2=1) .
value labels vv1
    1'חילוני'
    2'מסורתי'
    3'דתי'.
fre vv1.


CORRELATIONS
  /VARIABLES=sca1  sca2_1 sca2_2 sca2_3 sca3  sca4_1 sca4_2 with age  sex status
education
sex
vv1
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



CORRELATIONS
  /VARIABLES=
  sca1  sca2_1 sca2_2 sca2_3 sca3  sca4_1 sca4_2 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


DATASET ACTIVATE DataSet1.
UNIANOVA   sca1 sca3  sca2_1 sca2_2 sca2_3 sca4_1 sca4_2   BY vv1
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(vv1) COMPARE ADJ(BONFERRONI)
  /PRINT ETASQ DESCRIPTIVE
  /CRITERIA=ALPHA(.05)
  /DESIGN=vv1.



x1
x2
x3
x4
x5
x6
x7
x8
x9
x10
x11
x12
x13
x14
x15
x16
x17


CORRELATIONS
  /VARIABLES=x1
x2
x3
x4
x5
x6
x7
x8
x9
x10
x11
x12
x13
x14
x15
x16
x17 with sca1 sca3  sca2_1 sca2_2 sca2_3
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

fre x14.
t-test groups=sex(0,1)/variables=sca1
sca2_2
sca2_1
sca2_3
sca3
sca4_1
sca4_2.


* 137 sex=1.
fre sex.

temporary.
select if (mis(sex)=1).
des sca1
sca2_2
sca2_1
sca2_3
sca3
sca4_1
sca4_2.


fre v2 v3.

CORRELATIONS
  /VARIABLES= v2 v3  u1
u2
u3
u4
u5
u6
u7
u8
u9 with 
  sca4_1
sca4_2  sca3  sca1 sca2_1 sca2_2 sca2_3 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

t-test groups=v3(0,1)/variables=sca4_1
sca4_2  sca3  sca1 sca2_1 sca2_2 sca2_3 


fre u1
u2
u3
u4
u5
u6
u7
u8
u9.
fre age.

CORRELATIONS
  /VARIABLES= v2 v3 
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

fre u8.
fre sca10.
compute sca10=0.
if (v2=1) sca10=1.
if (v3=1) sca10=1.
fre sca10.



CORRELATIONS
  /VARIABLES= u2 u3 v2 v3
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


cro v2 by v3.


t-test groups=sca10(0,1)/variables=sca4_1
sca4_2  sca3  sca1 sca2_1 sca2_2 sca2_3 


CORRELATIONS
  /VARIABLES= sca2_1 sca2_2 sca2_3  with sca3
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



compute isca10sca4_1=sca10*sca4_1.
compute isca10sca4_2=sca10*sca4_2.
compute isca10sca3=sca10*sca3.
exe.




REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex sca10 sca4_1 sca4_2 sca3/enter isca10sca4_1
isca10sca4_2
isca10sca3.

temporary.
select if (sca10=0).
CORRELATIONS
  /VARIABLES= sca4_1 sca4_2 with sca1
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



temporary.
select if (sca10=1).
CORRELATIONS
  /VARIABLES= sca4_1 sca4_2 with sca1
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.



fre x1
x2
x3
x4
x5
x6
x7
x8
x9
x10
x11
x12
x13
x14
x15
x16
x17
 sca1.

CORRELATIONS
  /VARIABLES=x1
x2
x3
x4
x5
x6
x7
x8
x9
x10
x11
x12
x13
x14
x15
x16
x17
 with sca1
  /PRINT=TWOTAIL NOSIG FULL
/MISSING=PAIRWISE.




CORRELATIONS
  /VARIABLES=sca4_1 sca4_2 
 with sca1
  /PRINT=TWOTAIL NOSIG FULL
/MISSING=PAIRWISE.

des x2,x7,x6 x4 x5.

RELIABILITY
  /VARIABLES=x2,x7,x6  x5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=x4,x5,x6
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca100=means(x4,x5,x6).
variable labels sca100 'שימוש במדיה מסורתית'.
des sca100.

RELIABILITY
  /VARIABLES=x1,x12,x13,x14,x15
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.
compute sca101=means(x1,x12,x13,x14,x15).
variable labels sca101 'שימוש במדיה דיגיטלית'.
des sca101.



CORRELATIONS
  /VARIABLES=sca100 sca101
 with sca1
  /PRINT=TWOTAIL NOSIG FULL
/MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES=sca100 sca101
 with sca4_1 sca4_2
  /PRINT=TWOTAIL NOSIG FULL
/MISSING=PAIRWISE.

fre sex/.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex /enter sca100 sca101.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex /enter sca4_1 sca4_2.


CORRELATIONS
  /VARIABLES=sca4_1 sca4_2 
 with sca1
  /PRINT=TWOTAIL NOSIG FULL
/MISSING=PAIRWISE.



FACTOR
  /VARIABLES x1,x12,x13,x14 
x2,x5, x6,x7
  /MISSING LISTWISE 
  /ANALYSIS x1,x12,x13,x14 
x2,x5, x6,x7
  /PRINT INITIAL EXTRACTION ROTATION
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA factor(2) ITERATE(25)
  /EXTRACTION PAF
  /CRITERIA ITERATE(25)
  /ROTATION PROMAX(4)
  /METHOD=CORRELATION.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex /enter sca4_2.


temporary.
select if (sca10=0).
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex sca4_1 sca4_2 sca3 .


temporary.
select if (sca10=1).
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex sca4_1 sca4_2 sca3 .

fre sca10.

des sca4_1 sca4_2.
*Simple moderation .
process y=sca1 /x=sca4_1 /w=sca10 /total=1/cov=age sex sca4_2 sca3 /intprobe = .99/model=1/plot=1/seed=14830.
process y=sca1 /x=sca4_2 /w=sca10 /total=1/cov=age sex sca4_1 sca3 /intprobe = .99/model=1/plot=1/seed=14830.



process vars = calling livecall carcomm workmean jobsat/y = jobsat/m = carcomm 
 workmean/x = calling/w = livecall/model = 7/boot = 5000/seed=34421.



t-test groups=sca10(0,1)/variables=sca4_1 sca4_2 sca1.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca1
  /METHOD=ENTER age sex sca4_1 sca4_2 sca3 sca10 .

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca4_1
  /METHOD=ENTER age sex  sca10.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca4_2
  /METHOD=ENTER age sex  sca10.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca2_1
  /METHOD=ENTER age sex sca4_1 sca4_2 sca3 sca10 sca1.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca2_2
  /METHOD=ENTER age sex sca4_1 sca4_2 sca3 sca10 sca1.



REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT sca2_3
  /METHOD=ENTER age sex sca4_1 sca4_2 sca3 sca10 sca1.

recode all (sysmis=-99).
des all.

recode all (-99=sysmis).
des all.


*(7) Moderated Mediation.
process y=sca2_1 /x=sca4_1 /m=sca1/w=sca10/total=1/cov=age sex sca4_2 sca3 /model=7/seed=14830.
process y=sca2_2 /x=sca4_1 /m=sca1/w=sca10/total=1/cov=age sex sca4_2 sca3 /model=7/seed=14830.
process y=sca2_3 /x=sca4_1 /m=sca1/w=sca10/total=1/cov=age sex sca4_2 sca3 /model=7/seed=14830.

process y=sca2_1 /x=sca4_2 /m=sca1/w=sca10/total=1/cov=age sex sca4_1 sca3 /model=7/seed=14830.
process y=sca2_2 /x=sca4_2 /m=sca1/w=sca10/total=1/cov=age sex sca4_1 sca3 /model=7/seed=14830.
process y=sca2_3 /x=sca4_2 /m=sca1/w=sca10/total=1/cov=age sex sca4_1 sca3 /model=7/seed=14830.

