#!/usr/local/bin/expect -f

set output [lindex $argv 0]
set ipaddress [lindex $argv 1]
set user [lindex $argv 2]
set pass [lindex $argv 3]

log_file -noappend $output

set timeout 10

spawn ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null cli@$ipaddress
expect "*assword:"
send -- "cli\n"
expect "*name:"
send -- "$user\n"
#expect "*#"
expect "*assword:"
send -- "$pass\n"
expect {
 "Password authentication failed. Try again." {
  send_user -- "***Incorrect Login Credential, Pls Retry***\n"
  exit
}
"Last Login" {
#expect "*#"
expect "Do you acknowledge? (Y/N)?"
send -- "Y\n"
expect "*#"
send -- "sh alm prfl none eqpt cardinit\n"
expect "*#"
send -- "mm \n"
expect "*#"
send -- "logout\n"
}
}
expect eof
