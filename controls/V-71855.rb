# encoding: utf-8
#
DISABLE_SLOW_CONTROLS = attribute(
  'disable_slow_controls',
  default: false,
  description: 'If enabled, this attribute disables this control and other
                controls that consistently take a long time to complete.')
control "V-71855" do
  title "The cryptographic hash of system files and commands must match vendor
values."
  desc  "
    Without cryptographic integrity protections, system command and files can
be altered by unauthorized users without detection.

    Cryptographic mechanisms used for protecting the integrity of information
include, for example, signed hash functions using asymmetric cryptography
enabling distribution of the public key to verify the hash information while
maintaining the confidentiality of the key used to generate the hash.
  "
  impact 0.7
  tag "gtitle": "SRG-OS-000480-GPOS-00227"
  tag "gid": "V-71855"
  tag "rid": "SV-86479r2_rule"
  tag "stig_id": "RHEL-07-010020"
  tag "cci": ["CCI-000663"]
  tag "documentable": false
  tag "nist": ["SA-7", "Rev_4"]
  tag "subsystems": ['rpm', 'package']
  tag "check": "Verify the cryptographic hash of system files and commands
match the vendor values.

Check the cryptographic hash of system files and commands with the following
command:

Note: System configuration files (indicated by a \"c\" in the second column)
are expected to change over time. Unusual modifications should be investigated
through the system audit log.

# rpm -Va | grep '^..5'

If there is any output from the command for system binaries, this is a finding."
  tag "fix": "Run the following command to determine which package owns the
file:

# rpm -qf <filename>

The package can be reinstalled from a yum repository using the command:

# sudo yum reinstall <packagename>

Alternatively, the package can be reinstalled from trusted media using the
command:

# sudo rpm -Uvh <packagename>"
  tag "fix_id": "F-78207r1_fix"
# Command expects that we will only have changed config files (i.e. files denoted with 'c')
# We have purposely excluded /etc/inittab as this isn't considered a config file by RPM
# but will be changed stig::inittab cookbook to make the system STIG compliant for single-user
# mode booting. Excluding this file in your check below prevents a false positive finding.
# Broken - caused a false positive for /etc/inittab
#  describe command("rpm -Va | grep '^..5' | awk -F' ' '{ print $2 }'") do
#    its('stdout.strip') { should_not include 'b' }
  if DISABLE_SLOW_CONTROLS
    describe "This control consistently takes a long to run and has been disabled
    using the DISABLE_SLOW_CONTROLS attribute." do
      skip "This control consistently takes a long to run and has been disabled
      using the DISABLE_SLOW_CONTROLS attribute. You must enable this control for a
      full accredidation for production."
end
  else
    # Fixed to avoid false positive finding by excluding /etc/inittab from changed files list
    describe command("rpm -Va | grep '^..5' | grep -v '/etc/inittab' | awk -F' ' '{ print $2 }'") do
      its('stdout.strip') { should match %r{^((c)*(\\n)*)*$} }
    end
  end
end
