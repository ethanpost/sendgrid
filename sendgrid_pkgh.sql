
-- ToDo: Had some trouble sending multiline html with " and some other chars in it.

-- uninstall: drop package sendgrid;
create or replace package sendgrid as 
   
   -- Note:
   -- sendgrid_api_key and sendgrid_from_address must be set in saas_config or saas_instance packages.
   
   sendgrid_api_url varchar2(120) := 'https://api.sendgrid.com/v3/mail/send';

   procedure send_message (
      to_address varchar2,
      subject varchar2,
      message varchar2);

end;
/
