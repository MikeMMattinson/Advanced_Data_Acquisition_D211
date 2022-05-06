these were the original files sent to me by Dr. Sewell. there are a couple of mistakes in the files that need to be addressed

1. contract "Month-to-month" doesn't import... i ended up fixing it manually inside of pgAdmin after noticing that is didn't import. the header is missing, i fixed it and now it works.

2. The maximum length of job_title in the job.csv file exceeds the varchar(20) definition in the create table SQL file, increaase to varchar(60)

3. 2. The maximum length of city and county in the location.csv file exceeds the varchar(20) definition in the create table SQL file, increaase both to varchar(30)