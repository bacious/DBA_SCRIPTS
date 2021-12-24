-- Plan from the Shared Pool
select * from table(dbms_xplan.display_cursor('SQL_ID',null,'ALL'));

-- Plan from the AWR
select * from table(dbms_xplan.display_awr('SQL_ID',null,null,'ALL'));
select * from table(dbms_xplan.display_awr('SQL_ID',null,DBID,'ALL'));


-- kill all sessions executing a bad SQL
select 
     'alter system kill session '''|| s.SID||',' || s.serial# ||''';' 
    from v$session s
where s.sql_id='&SQL_ID';



-- Kill all sessions waiting for specific events by a specific user
select       'alter system kill session '''|| s.SID||',' || s.serial# ||''';' 
from gv$session s
where 1=1 
and (event='latch: shared pool' or event='library cache lock') and s.USERNAME='DBSNMP';



-- generate commands to kill all sessions from a specific user on specific instance
select 'alter system kill session '''|| SID||',' || serial# ||''' immediate;' from gv$session where username='BAD_USER' and inst_id=1;
