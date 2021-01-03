create or replace package body sendgrid as 

function get_json_body (
   from_address varchar2,
   to_address varchar2,
   subject varchar2,
   message varchar2) return varchar2 is 
   r varchar2(32000);
begin 
   r := '
{
   "personalizations": [{
      "to": [{
         "email": "'||to_address||'"
      }]
   }],
   "from": {
      "email": "'||from_address||'"
   },
   "subject": "'||subject||'",
   "content": [{
      "type": "text/plain",
      "value": "'||message||'"
   }]
}';
   return r;
exception 
   when others then 
      raise;
end;

procedure send_message (
   to_address varchar2,
   subject varchar2,
   message varchar2) is 
   r varchar2(32000);
   b varchar2(32000);
begin 
   arcsql.debug('send_message: '||to_address||'~'||subject||'~'||message);
   apex_web_service.g_request_headers.delete();
   apex_web_service.g_request_headers(1).name := 'Authorization';  
   apex_web_service.g_request_headers(1).value := 'Bearer '||arcsql.get_setting('sendgrid_api_key');  
   apex_web_service.g_request_headers(2).name := 'Content-Type';
   apex_web_service.g_request_headers(2).value := 'application/json'; 
   arcsql.debug('sendgrid_api_key: '||arcsql.get_setting('sendgrid_api_key'));
   b := get_json_body(
         from_address=>arcsql.get_setting('sendgrid_from_address'), 
         to_address=>send_message.to_address, 
         subject=>send_message.subject, 
         message=>send_message.message);
   arcsql.debug(b);
   r := apex_web_service.make_rest_request(
      p_url         => sendgrid.sendgrid_api_url, 
      p_http_method => 'POST',
      p_body => to_clob(b));
   if instr(lower(r), 'errors') > 0 then 
      raise_application_error(-20001, 'send_message: '||r);
   end if;
   arcsql.debug(r);
exception
   when others then 
      arcsql.log_err(error_text=>'send_message: '||dbms_utility.format_error_stack);
      if arcsql.is_dev then raise; end if;
end;

end;
/
