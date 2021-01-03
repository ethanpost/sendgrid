
/* 
You will need to set related configuration values in the 
arcsql_user_setting package or the arcsql_config table.
Review arcsql_default_setting package to see which values need to be set.
*/

whenever sqlerror exit failure;
-- set echo on

exec arcsql.set_app_version('sendgrid', .01);

@sendgrid_pkgh.sql 
@sendgrid_pkgb.sql 

exec arcsql.confirm_app_version('sendgrid');
