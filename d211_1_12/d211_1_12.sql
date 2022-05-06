/*
 Data: Wgu Telcom Churn SQL data
 
 Description: count total number of loyal customers
 
 Author: mike mattinson
 
 Date: April 13, 2022

*/

SELECT COUNT ( DISTINCT customer_id ) AS "# Loyal Cust" 
FROM customer 
where churn = 'No';







/*
 Data: Wgu Telcom Churn SQL data
 
 Description: simple query using
 natural join on three tables.
 
 Author: mike mattinson
 
 Date: April 13, 2022

+---------+---------------+-----------------+
| CUST_ID |     CITY      |       JOB       |
+---------+---------------+-----------------+
| K409198 | Calhoun       | Environmental h |
| S120509 | Neptune Beach | Programmer- mul |
| K191035 | Linesville    | Chief Financial |
| D90850  | Dawson        | Solicitor       |
| K662701 | Sabana Seca   | Medical illustr |
+---------+---------------+-----------------+

*/

select 
	left(c.customer_id,99) as "CUST_ID",
	left(l.city,15) as "CITY",
	left(j.job_title,15) as "JOB" 
	
from customer c 

natural join job j 

natural join location l

limit 5;


/*
 Data: Wgu Telcom Churn SQL data
 
 Description: subquery multi-row
 
 Author: mike mattinson
 
 Date: April 13, 2022

+---------+----------------+-------+
| CUST_ID |      CITY      | STATE |
+---------+----------------+-------+
| J266332 | Snowville      | UT    |
| R176145 | Salt Lake City | UT    |
| Y531744 | Altamont       | UT    |
| I196323 | Salina         | UT    |
| D904626 | Morgan         | UT    |
+---------+----------------+-------+

*/

select 
	left(c.customer_id,99) as "CUST_ID",
	l.city as "CITY",
	l.state as "STATE"
	
from customer c 

natural join location l

where location_id in
	(
		select location_id 
		from location
		where state='UT'
	)

limit 5;




/*
 Data: Wgu Telcom Churn SQL data
 
 Description: create table of us_codes
	state_id - 2 letter unique state id
	state - state name
	abbreviation - short abbreviation
	code - 2 letter state code
 
 Author: mike mattinson
 
 Date: April 13, 2022



*/
-- new table for us states codes and abbreviations
create table us_codes ( 
	state_id varchar(2), 
	State varchar(25), 
	Abbrev varchar(10),
	Code varchar(2),
	CONSTRAINT us_codes_pkey PRIMARY KEY (state_id)
);



/*
 Data: Wgu Telcom Churn SQL data
 
 Description: select * from us_codes;
 
 Author: mike mattinson
 
 Date: April 13, 2022

+----------+------------+--------+------+
| state_id |   state    | abbrev | code |
+----------+------------+--------+------+
| al       | Alabama    | Ala.   | AL   |
| ak       | Alaska     | Alaska | AK   |
| az       | Arizona    | Ariz.  | AZ   |
| ar       | Arkansas   | Ark.   | AR   |
| ca       | California | Calif. | CA   |
+----------+------------+--------+------+

*/
-- new table for us states codes and abbreviations
select * 
from us_codes
limit 5;



/*
 Data: Wgu Telcom Churn SQL data
 
 Description: locations with state abbreviation
 
 Author: mike mattinson
 
 Date: April 13, 2022

+--------+---------------+-------+--------+
| LOC_ID |     CITY      | STATE | ABBREV |
+--------+---------------+-------+--------+
|   5599 | Calhoun       | IL    | Ill.   |
|   2737 | Neptune Beach | FL    | Fla.   |
|   1297 | Linesville    | PA    | Pa.    |
|   5181 | Dawson        | ND    | N.D.   |
|   3476 | London        | KY    | Ky.    |
+--------+---------------+-------+--------+

*/

select 
	l.location_id as "LOC_ID",
	l.city as "CITY",
	l.state as "STATE",
	uc.abbrev as "ABBREV"
	
	
from location l 

join us_codes uc on l.state=uc.code

limit 5;



/*
 delete (all records) from table;
*/
DELETE FROM contract;




-- Table: public.payment
-- DROP TABLE public.payment;
CREATE TABLE public.payment
(
    payment_id integer NOT NULL,
    payment_type text ,
    CONSTRAINT payment_pkey PRIMARY KEY (payment_id)
);


-- Table: public.location
-- DROP TABLE public.location;
CREATE TABLE public.location
(
    location_id integer NOT NULL,
    zip integer,
    city varchar(30),
    state varchar(2),
    county varchar(30),
    CONSTRAINT location_pkey PRIMARY KEY (location_id)
);

-- Table: public.job
-- DROP TABLE public.job;
CREATE TABLE public.job
(
    job_id integer NOT NULL,
    job_title varchar(60),
    CONSTRAINT job_pkey PRIMARY KEY (job_id)
);


-- Table: public.contract
-- DROP TABLE public.contract;
CREATE TABLE public.contract
(
    contract_id integer NOT NULL,
    duration VARCHAR(30),
    CONSTRAINT contract_pkey PRIMARY KEY (contract_id)
);


-- Table: public.customer
-- DROP TABLE public.customer;
CREATE TABLE public.customer
(
    customer_id text NOT NULL,
    lat numeric,
    lng numeric,
    population integer,
    children integer,
    age integer,
    income numeric,
    marital text ,
    churn text ,
    gender text ,
    tenure numeric,
    monthly_charge numeric,
    bandwidth_gp_year numeric,
    outage_sec_week numeric,
    email integer,
    contacts integer,
    yearly_equip_faiure integer,
    techie text,
    port_modem text ,
    tablet text ,
    job_id integer,
    payment_id integer,
    contract_id integer,
    location_id integer,
    CONSTRAINT customer_pkey PRIMARY KEY (customer_id),
    CONSTRAINT customer_contract_id_fkey FOREIGN KEY (contract_id)
        REFERENCES public.contract (contract_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT customer_job_id_fkey FOREIGN KEY (job_id)
        REFERENCES public.job (job_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT customer_location_id_fkey FOREIGN KEY (location_id)
        REFERENCES public.location (location_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT customer_payment_id_fkey FOREIGN KEY (payment_id)
        REFERENCES public.payment (payment_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

-- new table for the add-on for services
create table services ( 
	customer_id varchar(30), 
	internetservice varchar(25), 
	phone varchar(3),
	multiple varchar(3),
	Onlinesecurity varchar(3),
	Onlinebackup varchar(3),
	DeviceProtection varchar(3),
	techsupport varchar(3),
	CONSTRAINT services_pkey PRIMARY KEY (customer_id)
);

create table survey_responses ( 
	customer_id varchar(30),
	timely_responses int, 
	timely_fixes int, 
	timely_replacement int, 
	reliability int, 
	"options" int, 
	respectful int,
	courteous int,  
	active_listening int, 
	CONSTRAINT survey_responses_pkey PRIMARY KEY (customer_id)
);



/*
 Data: Wgu Telcom Churn SQL data
 
 Description: show customer city, state and region
 
 Author: mike mattinson
 
 Date: April 19, 2022



*/

select 
	left(c.customer_id,99) as "CUST_ID",
	c.location_id as "LOC_ID",
	left(l.city,15) as "CITY",
	l.state as "STATE"
	
from customer c 

natural join location l

;




I know this is an older post and not sure if anyone has found a workaround that is not cumbersome, but I found one. I cannot put my membership into the data because it will duplicate and counts not right because we divide by every 1000 members. I also tried countd of the items causing overcounting and that did not work. So my LOD solution to use 2 sources is this:

 

//the calc itself in source 1 sheet where I have parameters for Yes or No and it needs to be fixed so LOD

 

if [Display $ as Per 1K/Member Months] = 'Yes' then

{ fixed  [Funding], [Medical Policy Name]: 

((sum([Total Referred])+sum([Total Reconsidered]))*([Cost For Avg MD Review:])+ sum([Total Completed])*([Initial Review Costs:])+

sum([Total Nurse Rvw])*([Nurse Review Costs:])+ sum([Total Appeals])*([Cost For Avg Appeal:])+ sum([Total Iro])*([Cost For Avg IRO:])+

sum([Total Imr])*([Cost For Avg IMR:]))}

end

 

//2nd calculation to take above and get the 2nd data source that has membership

 

sum([Review Costs (All Funding Types for Selected Cut) PerK Calc]) / [TempROIMbrshpUM (tempdb)].[MemberMths]

 

Worked perfectly















