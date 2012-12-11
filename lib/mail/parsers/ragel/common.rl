%%{

  machine common;

  obs_NO_WS_CTL = 0x01..0x08 | 0x0b | 0x0c | 0x0e..0x1f | 0x7f;
  LF = "\n";
  CR = "\r";
  CRLF = "\r\n";
  WSP = 0x09 | 0x20;
  obs_ctext = obs_NO_WS_CTL;
  VCHAR = 0x21..0x7e;
  obs_qp = "\\" (0x00 | obs_NO_WS_CTL | LF | CR);
  obs_FWS = (CRLF? WSP)+;
  ctext = 0x21..0x27 | 0x2a..0x5b | 0x5d..0x7e | obs_ctext;
  quoted_pair = ("\\" (VCHAR | WSP)) | obs_qp;
  FWS = (WSP* CRLF WSP+) | (CRLF WSP+) | obs_FWS;
  ccontent = ctext | quoted_pair; # |comment
  ALPHA = [a-zA-Z];
  DIGIT = [0-9];
  obs_qtext = obs_NO_WS_CTL;
  comment = "(" (FWS? ccontent)* FWS? ")";
  atext = ALPHA | DIGIT | "!" | "#" | "$" | "%" | "&" | "'" | "*" | "+" | "-" | "/" | "=" | "?" | "^" | "_" | "`" | "{" | "|" | "}" | "~";
  qtext = 0x21 | 0x23..0x5b | 0x5d..0x7e | obs_qtext;
  obs_dtext = obs_NO_WS_CTL | quoted_pair;
  CFWS = ((FWS? comment)+ FWS?) | FWS;
  dot_atom_text = atext+ ("." atext+)*;
  DQUOTE = '"';
  qcontent = qtext | quoted_pair;
  dtext = 0x21..0x5a | 0x5e..0x7e | obs_dtext;
  atom = CFWS? atext+ CFWS?;
  dot_atom = CFWS? dot_atom_text CFWS?;
  quoted_string = CFWS? DQUOTE 
                  (((FWS? qcontent)+ FWS?) >mark %e_quoted_string)
                  DQUOTE CFWS?;
  domain_literal = CFWS? "[" (FWS? dtext)* FWS? "]" CFWS?;
  obs_domain = atom ("." atom)*;
  local_dot_atom_text = dot_atom;
  word = atom | quoted_string;
  domain = dot_atom | domain_literal | obs_domain;
  local_dot_atom = CFWS? local_dot_atom_text CFWS?;
  obs_local_part = word ("." word)*;
  obs_domain_list = (CFWS | ",")* "@" domain ("," CFWS? ("@" domain)?)*;
  local_part = local_dot_atom | quoted_string | obs_local_part;
  obs_phrase = (word | "." | "@")+;
  obs_route = obs_domain_list ":";
  addr_spec = (local_part "@" domain) | local_part;
  phrase = (obs_phrase | word+) >mark %e_phrase;
  obs_angle_addr = CFWS? "<" obs_route? addr_spec ">" CFWS?;
  display_name = phrase;
  angle_addr = CFWS? "<" addr_spec ">" CFWS? | obs_angle_addr;
  name_addr = display_name angle_addr | angle_addr;
  mailbox = name_addr | addr_spec;
  obs_mbox_list = (CFWS? ",")* mailbox ("," (mailbox | CFWS)?)*;
  token = 0x21..0x27 | 0x2a..0x2b | 0x2c..0x2e | 0x30..0x39 | 0x41..0x5a | 0x5e..0x7e;
  mailbox_list = (mailbox (("," | ";") mailbox)*) | obs_mbox_list;
  obs_group_list = (CFWS? ",")+ CFWS?;
  ietf_token = "7bit" | "8bit" | "binary" | "quoted-printable" | "base64";
  custom_x_token = [xX] "-" token+;
  group_list = mailbox_list | CFWS | obs_group_list;
  extension_token = ietf_token | custom_x_token;
  obs_id_left = local_part;
  no_fold_literal = "[" (dtext)* "]";
  obs_id_right = domain;
  group = display_name ":" group_list? ";" CFWS?;
  discrete_type = [tT] [eE] [xX] [tT] | [iI] [mM] [aA] [gG] [eE] | [aA] [uU] [dD] [iI] [oO] | [vV] [iI] [dD] [eE] [oO] | [aA] [pP] [pP] [lL] [iI] [cC] [aA] [tT] [iI] [oO] [nN] | extension_token;
  composite_type = [mM] [eE] [sS] [sS] [aA] [gG] [eE] | [mM] [uU] [lL] [tT] [iI] [pP] [aA] [rR] [tT] | extension_token;
  iana_token = token+;
  attribute = token+;
  value = quoted_string | (token | 0x3d)+;
  id_left = dot_atom_text | obs_id_left;
  id_right = dot_atom_text | no_fold_literal | obs_id_right;
  address = group | mailbox;
  main_type = discrete_type | composite_type;
  sub_type = extension_token | iana_token;
  parameter = CFWS? attribute "=" value CFWS?;
  msg_id = (CFWS)? "<" id_left "@" id_right ">" (CFWS)?;
  address_list = address? (FWS* ("," | ";") FWS* address?)*;
  obs_addr_list = (CFWS? ",")* address ("," (address | CFWS)?)*;
  location = quoted_string | ((token | 0x3d)+ >mark %e_token_string);
  content_type = main_type "/" sub_type (CFWS? ";"? parameter CFWS?)*;
  message_ids = msg_id (CFWS? msg_id)*;
  phrase_list = phrase ("," FWS* phrase)*;
  received_token = word | angle_addr | addr_spec | domain;
  obs_hour = CFWS? (DIGIT DIGIT) CFWS?;
  obs_minute = CFWS? (DIGIT DIGIT) CFWS?;
  obs_second = CFWS? (DIGIT DIGIT) CFWS?;
  day_name = "Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun";
  obs_day = CFWS? (DIGIT | (DIGIT DIGIT)) CFWS?;
  obs_year = CFWS? (DIGIT DIGIT DIGIT*) CFWS?;
  hour = DIGIT DIGIT | obs_hour;
  minute = DIGIT DIGIT | obs_minute;
  second = DIGIT DIGIT | obs_second;
  obs_zone = "UT" | "GMT" | "EST" | "EDT" | "CST" | "CDT" | "MST" | "MDT" | "PST" | "PDT" | 0x41..0x49 | 0x4B..0x5A | 0x61..0x69 | 0x6B..0x7A;
  obs_day_of_week = CFWS? day_name CFWS?;
  day = (FWS? DIGIT DIGIT? FWS) | obs_day;
  month = "Jan" | "Feb" | "Mar" | "Apr" | "May" | "Jun" | "Jul" | "Aug" | "Sep" | "Oct" | "Nov" | "Dec";
  year = FWS DIGIT DIGIT DIGIT DIGIT FWS | obs_year;
  time_of_day = hour ":" minute (":" second)?;
  zone = FWS ((("+" | "-") DIGIT DIGIT DIGIT DIGIT) | obs_zone);
  day_of_week = (FWS? day_name) | obs_day_of_week;
  date = day month year;
  time = time_of_day zone;
  date_time = (day_of_week ",")? (date >mark %e_date) <: (time >mark %e_time) CFWS?;
  version = CFWS?
            (DIGIT+ >mark %e_major_digits)
            comment? "." comment? 
            (DIGIT+ >mark %e_minor_digits)
            CFWS?;


}%%
