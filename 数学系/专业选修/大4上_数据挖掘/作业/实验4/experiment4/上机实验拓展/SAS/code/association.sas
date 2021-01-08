/*��ȡ�����ļ�association_data.xls*/
%macro grabpath ; 
%qsubstr(%sysget(SAS_EXECFILEPATH),1, %length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILEname))-5) 
%mend grabpath; 
%let path=%grabpath;
%let name=data\association_data.xls; 
%let pathname=&path&name; 
%put &pathname; /*pathnameΪassociation_data.xls��·��*/
%macro importdata ; 
PROC IMPORT OUT= WORK.association_data 
            DATAFILE="&pathname";/*���ú����pathname*/
            sheet="Sheet1";
			getnames=yes;
 RUN;
 %mend importdata;
 %importdata
/* Ϊ��ģ�������ݲֿ� */
proc dmdb data=association_data dmdbcat=dbcat;
class id content;
run; quit;
/* ����������� */
proc assoc data=association_data dmdbcat=dbcat pctsup=10 out=frequentItems;
id id;
target content;
run;
proc rulegen in=frequentItems dmdbcat=dbcat out=rules minconf=80;
run ;
/* �Թ���������������֧�ֶȽ������� */
proc sort data=rules;
by descending support;
run ;
/* �޳�ǰ�����H1��H2��H3��H4�Ĺ�����������ֻȡ����ֻ����H1��H2��H3��H4����һ��Ĺ����� */
data re_rules;
set rules(where=(set_size>1 and index(_lhand,'H')=0 and ( _rhand='H1' or _rhand='H2'or _rhand='H3'or _rhand='H4') ) ); 
run;
proc print data=re_rules;
var conf support lift rule ;
run ;
