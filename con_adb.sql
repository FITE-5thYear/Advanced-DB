//second

CREATE TEMPORARY TABLESPACE ts_temp TEMPFILE
'D:\ora\data\temp01.dbf' SIZE 100M;

//third
CREATE TABLESPACE homeworkts
DATAFILE 'D:\ora\data\datafile01.dbf' SIZE 250M ,
         'D:\ora\data\datafile02.dbf' SIZE 250M;
         
ALTER DATABASE  
DATAFILE 'D:\ora\data\datafile01.dbf' RESIZE 500M;

ALTER DATABASE  
DATAFILE 'D:\ora\data\datafile02.dbf' RESIZE 500M;

//fourth
CREATE PROFILE homeworkpf LIMIT
PRIVATE_SGA 200K
CONNECT_TIME 480
SESSIONS_PER_USER 5
PASSWORD_LIFE_TIME 14
FAILED_LOGIN_ATTEMPTS UNLIMITED;

//fifth
CREATE USER homeworku PROFILE homeworkpf
IDENTIFIED BY homeworku DEFAULT TABLESPACE homeworkts;
