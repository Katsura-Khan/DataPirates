create or replace trigger delete_student_trigger
after delete on students
for each row
declare
log_user varchar2(12);
log_table_name varchar2(12) default 'students'; 
log_operation varchar2(12) default 'delete';
log_key_value varchar2(14);
log_b# char(4);
begin
log_b# := :old.b#;
select user into log_user from dual;
log_key_value:=log_sequence.nextval;
  insert into logs values(log_key_value,log_user,sysdate,log_table_name,log_operation,log_b#);
  delete from enrollments where b#=log_b#;
 
  end;
/ 

create or replace trigger enrollments_trigger_insert
after insert on enrollments
for each row
declare
log_user varchar2(12);
log_table_name varchar2(12) default 'enrollments'; 
log_operation varchar2(12) default 'insert';
log_key_value varchar2(14);
log_b# char(4);
log_classid char(5);
log_concat varchar2(30);
begin
log_b# := :new.b#;
log_classid := :new.classid;
log_concat := (log_b#||','||log_classid);
select user into log_user from dual;
log_key_value:=log_sequence.nextval;
 insert into logs values(log_key_value,log_user,sysdate,log_table_name,log_operation,log_concat);
 update classes set class_size=class_size+1 where classid=log_classid;
 end;
/

create or replace trigger enrollments_trigger_delete
after delete on enrollments
for each row
declare
log_user varchar2(12);
log_table_name varchar2(12) default 'enrollments'; 
log_operation varchar2(12) default 'delete';
log_key_value varchar2(14);
log_b# char(4);
log_classid char(5);
log_concat varchar2(30);

begin
log_b# := :old.b#;
log_classid:= :old.classid;
log_concat := (log_b#||','||log_classid);

select user into log_user from dual;
log_key_value:=log_sequence.nextval;
 insert into logs values(log_key_value,log_user,sysdate,log_table_name,log_operation,log_concat);
 update classes set class_size=class_size-1 where classid=log_classid;
 end;
/
show errors