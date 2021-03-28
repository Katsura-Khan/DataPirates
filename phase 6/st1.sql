create or replace package body dbprocedure as
    procedure show_students(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from students;
    end show_students;
    procedure show_courses(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from courses;
    end show_courses;
    procedure show_course_credit(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from course_credit;
    end show_course_credit;
    procedure show_classes(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from classes;
    end show_classes;
    procedure show_enrollments(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select b#,classid,nvl(lgrade,' ') as lgrade from enrollments;
    end show_enrollments;
    procedure show_grades(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from grades;
    end show_grades;
    procedure show_prerequisites(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from prerequisites;
    end show_prerequisites;  
    procedure show_logs(stud_curs out sys_refcursor) as
    begin
    open stud_curs for
    select * from logs;
    end show_logs;
	procedure get_students_course_details(studentid_b# in students.b#%type,error_message out varchar2,r_cursor out sys_refcursor)
	is
	 student_count number;
	 student_course_count number;	
	begin
	select count(*) into student_course_count from enrollments where b#=studentid_b#; 
	select count(*) into student_count from students where b#= studentid_b#;
	if student_count = 0
	 then error_message := 'The B# is invalid';
	 else 
			if student_course_count = 0
				then error_message := 'The student has not taken any course.';
			else 
				open r_cursor for
				select cl.dept_code, cl.course#, co.title, cl.sect#, cl.year, cl.semester, e.lgrade, g.ngrade 
                from enrollments e inner join classes cl on cl.classid = e.classid left join grades g on g.lgrade = e.lgrade
				inner join courses co on co.dept_code||co.course# = cl.dept_code||cl.course# where e.b# = studentid_b#;

			end if;
	end if;
	end get_students_course_details;
	procedure get_prerequisites(dept_code_pre in prerequisites.dept_code%type, course#_pre in prerequisites.course#%type, r_cursor out sys_refcursor )
	is
    cursor pre_req_cursor is
    select pre_dept_code, pre_course# from prerequisites
    where dept_code = dept_code_pre
    and course#=course#_pre;
	
	pre_req_record pre_req_cursor%rowtype;    
	
	begin
		insert into prerequisites_temp select pre_dept_code,pre_course# from prerequisites where dept_code=dept_code_pre and course#=course#_pre;
		open pre_req_cursor;
		loop 
			fetch pre_req_cursor into pre_req_record;
			exit when pre_req_cursor%notfound;
		get_prerequisites(pre_req_record.pre_dept_code,pre_req_record.pre_course#,r_cursor);
    end loop; 
    open r_cursor for select * from prerequisites_temp;
    close pre_req_cursor;
    end get_prerequisites;
	procedure get_prerequisites_rev(dept_code_pre in prerequisites.dept_code%type, course#_pre in prerequisites.course#%type, r_cursor out sys_refcursor )
	is
    cursor pre_req_cursor is
    select dept_code, course# from prerequisites
    where pre_dept_code = dept_code_pre
    and pre_course#=course#_pre;
	
	pre_req_record pre_req_cursor%rowtype;    
	
	begin
		insert into prerequisites_temp select dept_code,course# from prerequisites where pre_dept_code=dept_code_pre and pre_course#=course#_pre;
		open pre_req_cursor;
		loop 
			fetch pre_req_cursor into pre_req_record;
			exit when pre_req_cursor%notfound;
		get_prerequisites_rev(pre_req_record.dept_code,pre_req_record.course#,r_cursor);
    end loop; 
    open r_cursor for select * from prerequisites_temp;
    close pre_req_cursor;
    end get_prerequisites_rev;
    procedure get_class_course_student(studentid_classid in classes.classid%type,message out varchar2,stud_curs out sys_refcursor)
    is 
    studentid_classid_count int;
    studentid_enroll_count int;
    begin
    select count(*) into studentid_classid_count from classes where classid=studentid_classid;
    select count(*) into studentid_enroll_count from enrollments where classid=studentid_classid;
    if studentid_classid_count>0
    then
        if studentid_enroll_count>0
        then
            open stud_curs for
        select cl.classid,cr.title,s.b#,s.firstname from students s,enrollments e,classes cl,courses cr
        where cl.classid=studentid_classid and cl.dept_code=cr.dept_code and cl.course#=cr.course# and s.b#=e.b# and e.classid=cl.classid;           
        else
        message:='No student has enrolled in the class.';  
        end if;
    else
        message:='The classid is invalid';
        end if;           
    end get_class_course_student;
	procedure delete_student(studentid_b# in students.b#%type,message out varchar)
	is
		studentid_count int;
	begin
		select count(*) into studentid_count from students where b#=studentid_b#;
	if studentid_count=0
	then
		message:='The B# is invalid.';
	else
		delete from students where b#=studentid_b#;
		commit;
		message:='student deleted sucessfully';
	end if;
    end delete_student;
	
	procedure drop_student(studentid_b# in students.b#%type,studentid_classid in classes.classid%type, message out varchar )
	is
        message1 varchar(50);
        studentid_class_enroll_cnt int;
        studentid_dept_code classes.dept_code%type; 
        message2 varchar(50);
		studentid_prereq_cnt int;
        studentid_class_size int;
        studentid_course# classes.course#%type;
		studentid_class_size_cnt int;
		studentid_count int;
        studentid_class_cnt int;
		
	begin
	select count(*) into studentid_count from students where b# = studentid_b#;
    select count(*) into studentid_class_cnt from classes where classid=studentid_classid;
	if studentid_count=0
	then
		message:='The B# is invalid';
		else
			if studentid_class_cnt=0
			then
				message:='The classid is invalid';
				else
					select count(*) into studentid_class_enroll_cnt from enrollments where classid=studentid_classid and b#=studentid_b#;
					if studentid_class_enroll_cnt=0
					then
						message:= 'The student is not enrolled in the class';
					else
						select dept_code,course# into studentid_dept_code,studentid_course# from classes where classid=studentid_classid;
						select count(*) into studentid_prereq_cnt from classes cl,prerequisites p where classid in (select classid from enrollments where classid<>studentid_classid and b#=studentid_b#) and 
						cl.dept_code=p.dept_code and cl.course# = p.course# and p.pre_dept_code=studentid_dept_code and p.pre_course#=studentid_course#;
	
					if studentid_prereq_cnt>0
					then
						message:='The drop is not permitted because another class uses it as a prerequisite';
                
					else
						delete from enrollments where b#=studentid_b# and classid=studentid_classid;
						message:='Student dropped successfully';
						
						select class_size into studentid_class_size from classes where classid=studentid_classid;
                    
						select count(*) into studentid_class_size_cnt from enrollments where b#=studentid_b#; 
                
						if studentid_class_size=0
						then 
							message1:='The class now has no students.';
						end if;
                
						if studentid_class_size_cnt=0
						then
							message2:='This student is not enrolled in any classes.';
						end if;
						message:=message||' '||message1||' '||message2;
						
						
						
					end if;
				end if;
			end if;
		end if;
     end drop_student ;
	 
	
	 procedure enroll_student(studentid_b# students.b#%type,studentid_classid classes.classid%type,message out varchar2)
    is 
        studentid_over_count number;
        studentid_prereq_count number;
        
        studentid_classid_count number;
        temp_cursor sys_refcursor;
        studentid_year_classid classes.year%type;
        studentid_sem_classid classes.semester%type;
        studentid_enroll char(200);
        temp_dept_code prerequisites.dept_code%type;
        temp_course# prerequisites.course#%type;
        studentid_classid_limit classes.limit%type;
        studentid_classid_clsize classes.class_size%type;
        temp_cursor_dept_code prerequisites.dept_code%type;
        temp_cursor_course prerequisites.course#%type;
        studentid_pre_temp_count int;
        studentid_b#_count number;
        ssce_count number;
        begin
        select count(*) into studentid_b#_count from students where b#=studentid_b#;
		select count(*) into studentid_classid_count from classes where classid=studentid_classid;
		
            if studentid_b#_count=0
            then
            message:='The B# is invalid.';
            else 
                if studentid_classid_count=0
                then 
                message:='The classid is invalid.'; 
                else
                    select limit,class_size into studentid_classid_limit,studentid_classid_clsize from classes where classid=studentid_classid;
                    if (studentid_classid_clsize+1) > studentid_classid_limit
                    then
                    message:='The class is full.';
                    else 
                        select count(*) into ssce_count from enrollments where b#=studentid_b# and classid=studentid_classid;
                        if(ssce_count > 0)
                        then
                        message:='The student is already in the class.';
                        else 
                        
                        select dept_code,course# into temp_dept_code,temp_course# from classes where classid=studentid_classid;
                       
                        select count(*) into studentid_pre_temp_count from prerequisites where dept_code=temp_dept_code and course#=temp_course#;
                        
                               if studentid_pre_temp_count=0
                               then     
                                   select year,semester into studentid_year_classid,studentid_sem_classid from classes where classid=studentid_classid;
                                   select count(*)into studentid_over_count from enrollments where b#=studentid_b# and 
                                   classid in(select classid from classes where year=studentid_year_classid and semester=studentid_sem_classid and classid<>studentid_classid);
                                   
                                        if studentid_over_count>=4
                                        then 
                                        message:='Students cannot be enrolled in more than four classes in the same semester.';                 
                                        else 
                                        select year,semester into studentid_year_classid,studentid_sem_classid from classes where classid=studentid_classid;
                                        select count(*)into studentid_over_count from enrollments where b#=studentid_b# and 
                                        classid in(select classid from classes where year=studentid_year_classid and semester=studentid_sem_classid and classid<>studentid_classid);
                                   
                                        if studentid_over_count=3
                                        then
                                            studentid_enroll:='You are overloaded';                   
                                            /*inserting the b#,classid values into enrollments table*/
                                            insert into enrollments(b#,classid) values(studentid_b#,studentid_classid);
                                            message:='Student with b#: '||studentid_b#||' has enrolled successfully'||'--'||studentid_enroll;  
                                        else 
                                            /*inserting the b#,classid values into enrollments table*/
                                           insert into enrollments(b#,classid) values(studentid_b#,studentid_classid);
                                           message:='Student - '||studentid_b#||' has enrolled successfully';     
                                    end if;    

                                   end if;
                               else 
                                 select dept_code,course# into temp_dept_code,temp_course# from classes where classid=studentid_classid;
                                 get_prerequisites(temp_dept_code,temp_course#,temp_cursor);
                                 
                                 loop
                                 fetch temp_cursor into temp_cursor_dept_code,temp_cursor_course;
                                 exit when temp_cursor%notfound;
                                 select count(*) into studentid_prereq_count from enrollments enr where enr.classid in (select classid from classes where dept_code=temp_cursor_dept_code and course#=temp_cursor_course) 
                                    and enr.lgrade is not null and enr.lgrade!='E' and enr.lgrade!='F' and enr.lgrade!='D' and enr.lgrade!='C-' and enr.b#=studentid_b#; 
                                
                                 end loop;
                                 
                                 if studentid_prereq_count>0
                                 then
                                    select year,semester into studentid_year_classid,studentid_sem_classid from classes where classid=studentid_classid;
                                    select count(*)into studentid_over_count from enrollments 
                                    where b#=studentid_b# and classid in(select classid from classes where year=studentid_year_classid and semester=studentid_sem_classid and classid<>studentid_classid);
                                   
                                    if studentid_over_count>=4
                                    then 
                                    message:='Students cannot be enrolled in more than four classes in the same semester.';                 
                                    else 
                                     
                                        select year,semester into studentid_year_classid,studentid_sem_classid from classes where classid=studentid_classid;
                                        select count(*)into studentid_over_count from enrollments where b#=studentid_b# and classid in(select classid from classes where year=studentid_year_classid and semester=studentid_sem_classid and classid<>studentid_classid);
                                        if studentid_over_count=3
                                        then
                                            studentid_enroll:='You are overloaded';                   
                                            insert into enrollments(b#,classid) values(studentid_b#,studentid_classid);
                                            message:='Student - '||studentid_b#||' has enrolled successfully'||'--'||studentid_enroll;  
                                        else 
                                           insert into enrollments(b#,classid) values(studentid_b#,studentid_classid);
                                           message:='Student - '||studentid_b#||' has enrolled successfully';     
                                    end if;    

                                   end if;
                               
                                   else
                                   message:='Prerequisite not satisfied.';
                               
                                    
                                end if;
                         
                           end if;
                       end if;
                    end if;
              end if;
            end if;
            end enroll_student;
	 
end dbprocedure;
/
show errors