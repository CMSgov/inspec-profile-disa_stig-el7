# encoding: utf-8
#

# TODO this should raise an error if the file doesn't exist
# TODO this can happen if `authconfig` has not been run on the system yet and
# TODO the system is still using the `non-ac` versions of the files yet.

MIN_REUSE_GENERATIONS = attribute('min_reuse_generations', default: 5,
description: 'The minimum number of generations before a password can be
reused.')

control "V-71933" do
  title "Passwords must be prohibited from reuse for a minimum of five
generations."
  desc  "Password complexity, or strength, is a measure of the effectiveness of
a password in resisting attempts at guessing and brute-force attacks. If the
information system or application allows the user to consecutively reuse their
password when that password has exceeded its defined lifetime, the end result
is a password that is not changed per policy requirements."
  impact 0.5
  tag "gtitle": "SRG-OS-000077-GPOS-00045"
  tag "gid": "V-71933"
  tag "rid": "SV-86557r2_rule"
  tag "stig_id": "RHEL-07-010270"
  tag "cci": ["CCI-000200"]
  tag "documentable": false
  tag "nist": ["IA-5 (1) (e)", "Rev_4"]
  tag "check": "Verify the operating system prohibits password reuse for a
minimum of five generations.

Check for the value of the \"remember\" argument in
\"/etc/pam.d/system-auth-ac\" with the following command:

# grep -i remember /etc/pam.d/system-auth-ac
password sufficient pam_unix.so use_authtok sha512 shadow remember=5

If the line containing the \"pam_unix.so\" line does not have the \"remember\"
module argument set, or the value of the \"remember\" module argument is set to
less than \"5\", this is a finding."
  tag "fix": "Configure the operating system to prohibit password reuse for a
minimum of five generations.

Add the following line in \"/etc/pam.d/system-auth-ac\" (or modify the line to
have the required value):

password sufficient pam_unix.so use_authtok sha512 shadow remember=5"
  tag "fix_id": "F-78285r2_fix"

  describe command("grep -Po '^password\s+sufficient\s+pam_unix.so.*$' /etc/pam.d/system-auth-ac | grep -Po '(?<=pam_unix.so).*$' | grep -Po 'remember\s*=\s*[0-9]+' | cut -d '=' -f2") do
    its('stdout.to_i') { should be >= MIN_REUSE_GENERATIONS }
  end
end
