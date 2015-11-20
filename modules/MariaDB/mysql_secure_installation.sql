UPDATE mysql.user SET Password=PASSWORD('MDBPASS') WHERE User='MDBADMIN';
DELETE FROM mysql.user WHERE User='MDBADMIN' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES; 
