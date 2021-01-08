/*读取数据文件association_data.xls*/
%macro grabpath ; 
%qsubstr(%sysget(SAS_EXECFILEPATH),1, %length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILEname))-5) 
%mend grabpath; 
%let path=%grabpath;
%let name=data\association_data.xls; 
%let pathname=&path&name; 
%put &pathname; /*pathname为association_data.xls的路径*/
%macro importdata ; 
PROC IMPORT OUT= WORK.association_data 
            DATAFILE="&pathname";/*引用宏变量pathname*/
            sheet="Sheet1";
			getnames=yes;
 RUN;
 %mend importdata;
 %importdata
/* 为建模创建数据仓库 */
proc dmdb data=association_data dmdbcat=dbcat;
class id content;
run; quit;
/* 关联规则过程 */
proc assoc data=association_data dmdbcat=dbcat pctsup=10 out=frequentItems;
id id;
target content;
run;
proc rulegen in=frequentItems dmdbcat=dbcat out=rules minconf=80;
run ;
/* 对关联规则输出结果按支持度降序排序 */
proc sort data=rules;
by descending support;
run ;
/* 剔除前项包含H1、H2、H3、H4的规则结果，并且只取后项只包含H1、H2、H3、H4其中一项的规则结果 */
data re_rules;
set rules(where=(set_size>1 and index(_lhand,'H')=0 and ( _rhand='H1' or _rhand='H2'or _rhand='H3'or _rhand='H4') ) ); 
run;
proc print data=re_rules;
var conf support lift rule ;
run ;
