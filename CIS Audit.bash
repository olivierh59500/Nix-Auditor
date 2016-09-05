#!/bin/bash

#help function
usage () 
{ 
echo -e "\n\e[00;31m%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\e[00m" 
echo -e "\e[00;31m#\e[00m" "\e[00;33m Unofficial CIS Audit Script ^Tested on RHEL 6,7... CentOS 6,7 ^\e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;31m%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\e[00m"
echo -e "\e[00;33m# For best results, run as ROOT. Always be ROOT. *Evil grin*"
echo -e "\e[00;33m# https://github.com/Alfien/CIS-Audit"
echo -e "\e[00;33m# $version\e[00m\n" |tee -a $report 2>/dev/null	
echo -e "\e[00;31m#########################################################\e[00m"		
}
while getopts "h:k:r:e:t" option; do
 case "${option}" in
	  k) keyword=${OPTARG};;
	  r) report=${OPTARG}"-"`date +"%d-%m-%y"`;;
	  e) export=${OPTARG};;
	  t) thorough=1;;
	  h) usage; exit;;
	  *) usage; exit;;
 esac
done

echo -e "\n\e[00;31m%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\e[00m" |tee -a $report 2>/dev/null
echo -e "\e[00;31m#\e[00m" "\e[00;33m Unofficial CIS Audit Script ^Tested on RHEL 6,7... CentOS 6,7 ^\e[00m" "\e[00;31m#\e[00m" |tee -a $report 2>/dev/null
echo -e "\e[00;31m%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\e[00m" |tee -a $report 2>/dev/null
echo -e "\e[00;33m# For best results, run as ROOT. Always be ROOT. *Evil grin*"
echo -e "\e[00;33m# https://github.com/Alfien/CIS-Audit"
echo -e "\e[00;33m# $version\e[00m\n" |tee -a $report 2>/dev/null
echo -e "\e[00;31m#########################################################\e[00m"

if [ "$keyword" ]; then 
	echo "keyword = $keyword" |tee -a $report 2>/dev/null
else 
	:
fi

if [ "$report" ]; then 
	echo "report name = $report" |tee -a $report 2>/dev/null
else 
	:
fi

if [ "$export" ]; then 
	echo "export location = $export" |tee -a $report 2>/dev/null
else 
	:
fi

sleep 2

if [ "$export" ]; then
  mkdir $export 2>/dev/null
  format=$export/`date +"%d-%m-%y_%H:%M"`
  mkdir $format 2>/dev/null
else 
  :
fi

who=`whoami` |tee -a $report 2>/dev/null
echo -e "\n" |tee -a $report 2>/dev/null

echo -e "\e[00;31mScan started at:"; date |tee -a $report 2>/dev/null
echo -e "\e[00;33m\n" |tee -a $report 2>/dev/null

echo -e "\e[00;31m%%%%% Sysinfo %%%%\e[00m" |tee -a $report 2>/dev/null

#basic kernel info
unameinfo=`uname -a 2>/dev/null`
if [ "$unameinfo" ]; then
  echo -e "\e[00;33mKernel info:\e[00m\n$unameinfo" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

procver=`cat /proc/version 2>/dev/null`
if [ "$procver" ]; then
  echo -e "\e[00;33mKernel versions:\e[00m\n$procver" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

#search all *-release files for version info
release=`cat /etc/*-release 2>/dev/null`
if [ "$release" ]; then
  echo -e "\e[00;33mSpecific release information:\e[00m\n$release" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

#target hostname info
hostnamed=`hostname 2>/dev/null`
if [ "$hostnamed" ]; then
  echo -e "\e[00;33mHostname:\e[00m\n$hostnamed" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

echo -e "\e[00;31m%%% USER/GROUP %%%\e[00m" |tee -a $report 2>/dev/null

#current user details
currusr=`id 2>/dev/null`
if [ "$currusr" ]; then
  echo -e "\e[00;33mCurrent user/group info:\e[00m\n$currusr" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

#last logged on user information
lastlogedonusrs=`lastlog |grep -v "Never" 2>/dev/null`
if [ "$lastlogedonusrs" ]; then
  echo -e "\e[00;31mUsers that have previously logged onto the system:\e[00m\n$lastlogedonusrs" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

#strips out username uid and gid values from /etc/passwd
usrsinfo=`cat /etc/passwd | cut -d ":" -f 1,2,3,4 2>/dev/null`
if [ "$usrsinfo" ]; then
  echo -e "\e[00;31mAll users and uid/gid info:\e[00m\n$usrsinfo" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

#lists all id's and respective group(s)
grpinfo=`for i in $(cat /etc/passwd 2>/dev/null| cut -d":" -f1 2>/dev/null);do id $i;done 2>/dev/null`
if [ "$grpinfo" ]; then
  echo -e "\e[00;31mGroup memberships:\e[00m\n$grpinfo" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi

#checks to see if any hashes are stored in /etc/passwd
hashesinpasswd=`grep -v '^[^:]*:[x]' /etc/passwd 2>/dev/null`
if [ "$hashesinpasswd" ]; then
  echo -e "\e[00;33mPassword hashes in /etc/passwd!\e[00m\n$hashesinpasswd" |tee -a $report 2>/dev/null
  echo -e "\n" |tee -a $report 2>/dev/null
else 
  :
fi


 echo -e "\e[mGeneral CIS Checks start here :-)" |tee -a $report 2>/dev/null
 
 
#This script will run through several checks and for each check output to the terminal 'Passed' or 'Failed'
#The checks are designed to test whether or not the host conforms to the benchmarks in the following documents:
#>https://benchmarks.cisecurity.org/tools2/linux/CIS_CentOS_Linux_7_Benchmark_v1.1.0.pdf
#>https://benchmarks.cisecurity.org/tools2/linux/CIS_Red_Hat_Enterprise_Linux_7_Benchmark_v1.0.0.pdf
#All credits to https://benchmarks.cisecurity.org. <<< Thanks Good People!!!
echo For best results use root.** Always be root** *Evil grin* Credits, bugs, comments >>inbox2alfie@gmail.com

#The script doesn't change any config to your system, only many greps :-)
# ***yum-update manenos*

FSTAB='/etc/fstab'
YUM_CONF='/etc/yum.conf'
GRUB_CFG='/boot/grub2/grub.cfg'
GRUB_DIR='/etc/grub.d'
SELINUX_CFG='/etc/selinux/config'
NTP_CONF='/etc/ntp.conf'
SYSCON_NTPD='/etc/sysconfig/ntpd'
LIMITS_CNF='/etc/security/limits.conf'
SYSCTL_CNF='/etc/sysctl.conf'
CENTOS_REL='/etc/centos-release'
LATEST_REL_STR='CentOS Linux release 7.1.1503 (Core)'
HOSTS_ALLOW='/etc/hosts.allow'
HOSTS_DENY='/etc/hosts.deny'
CIS_CNF='/etc/modprobe.d/CIS.conf'
RSYSLOG_CNF='/etc/rsyslog.conf'
AUDITD_CNF='/etc/audit/auditd.conf'
AUDIT_RULES='/etc/audit/audit.rules'
LOGR_SYSLOG='/etc/logrotate.d/syslog'
ANACRONTAB='/etc/anacrontab'
CRONTAB='/etc/crontab'
CRON_HOURLY='/etc/cron.hourly'
CRON_DAILY='/etc/cron.daily'
CRON_WEEKLY='/etc/cron.weekly'
CRON_MONTHLY='/etc/cron.monthly'
CRON_DIR='/etc/cron.d'
AT_ALLOW='/etc/at.allow'
AT_DENY='/etc/at.deny'
CRON_ALLOW='/etc/cron.allow'
CRON_DENY='/etc/cron.deny'
SSHD_CFG='/etc/ssh/sshd_config'
SYSTEM_AUTH='/etc/pam.d/system-auth'
PWQUAL_CNF='/etc/security/pwquality.conf'
PASS_AUTH='/etc/pam.d/password-auth'
PAM_SU='/etc/pam.d/su'
GROUP='/etc/group'
LOGIN_DEFS='/etc/login.defs'
PASSWD='/etc/passwd'
SHADOW='/etc/shadow'
GSHADOW='/etc/gshadow'
BASHRC='/etc/bashrc'
PROF_D='/etc/profile.d'
MOTD='/etc/motd'
ISSUE='/etc/issue'
ISSUE_NET='/etc/issue.net'
BANNER_MSG='/etc/dconf/db/gdm.d/01-banner-message'

function separate_partition {
  # Test that the supplied $1 is a separate partition

  local filesystem="${1}"
  grep -q "[[:space:]]${filesystem}[[:space:]]" "${FSTAB}" || return
}

function mount_option {
  # Test the the supplied mount option $2 is in use on the supplied filesystem $1

  local filesystem="${1}"
  local mnt_option="${2}"

  grep "[[:space:]]${filesystem}[[:space:]]" "${FSTAB}" | grep -q "${mnt_option}" || return

  mount | grep "[[:space:]]${filesystem}[[:space:]]" | grep -q "${mnt_option}" || return
}

function bind_mounted_to {
  # Test that a directory /foo/dir is bind mounted onto a particular filesystem

  local directory="${1}"
  local filesystem="${2}"
  local E_NO_MOUNT_OUTPUT=1

  grep "^${filesystem}[[:space:]]" "${FSTAB}" | grep -q "${directory}" || return

  local grep_mount
  grep_mount=$(mount | grep "^${filesystem}[[:space:]]" | grep "${directory}")
  #If $directory doesn't appear in the mount output as mounted on the $filesystem  
  #it may appear in the output as being mounted on the same device as $filesystem, check for this
  local fs_dev
  local dir_dev
  fs_dev="$(mount | grep "[[:space:]]${filesystem}[[:space:]]" | cut -d" " -f1)"
  dir_dev="$(mount | grep "[[:space:]]${directory}[[:space:]]" | cut -d" " -f1)"
  if [[ -z "${grep_mount}" ]] && [[ "${fs_dev}" != "${dir_dev}" ]] ; then
    return "${E_NO_MOUNT_OUTPUT}"
  fi
}

function test_disable_mounting {
  # Test the the supplied filesystem type $1 is disabled

  local module="${1}"
  modprobe -n -v ${module} | grep -q "install \+/bin/true" || return 

  lsmod | grep -qv "${module}" || return
}

function centos_gpg_key_installed {
  # Test CentOS GPG Key is installed
  local centos_off_str='gpg(CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>)'
  rpm -q --queryformat "%{SUMMARY}\n" gpg-pubkey | grep -q "${centos_off_str}" || return
}

function yum_gpgcheck {
  # Check that gpgcheck is Globally Activated
  cut -d \# -f1 ${YUM_CONF} | grep 'gpgcheck' | grep -q 'gpgcheck=1' || return
}

function yum_update {
  # Check for outstanding pkg update with yum
  yum -q check-update || return
}

function pkg_integrity {
  # Verify the installed packages by comparing the installed files against file info stored in the pkg
  local rpm_out
  rpm_out="$(rpm -qVa | awk '$2 != "c" { print $0}')"
  [[ -z "${rpm_out}" ]] || return
}

function rpm_installed {
  # Test whether an rpm is installed

  local rpm="${1}"
  local rpm_out
  rpm_out="$(rpm -q --queryformat "%{NAME}\n" ${rpm})"
  [[ "${rpm}" = "${rpm_out}" ]] || return
}

function verify_aide_cron {
  # Verify there is a cron job scheduled to run the aide check
  crontab -u root -l | cut -d\# -f1 | grep -q "aide \+--check" || return
}

function verify_selinux_grubcfg {
  # Verify SELinux is not disabled in grub.cfg file 

  local grep_out1
  grep_out1="$(grep selinux=0 ${GRUB_CFG})"
  [[ -z "${grep_out1}" ]] || return

  local grep_out2
  grep_out2="$(grep enforcing=0 ${GRUB_CFG})"
  [[ -z "${grep_out2}" ]] || return
}

function verify_selinux_state {
  # Verify SELinux configured state in /etc/selinux/config
  cut -d \# -f1 ${SELINUX_CFG} | grep 'SELINUX=' | tr -d '[[:space:]]' | grep -q 'SELINUX=enforcing' || return
}

function verify_selinux_policy {
  # Verify SELinux policy in /etc/selinux/config
  cut -d \# -f1 ${SELINUX_CFG} | grep 'SELINUXTYPE=' | tr -d '[[:space:]]' | grep -q 'SELINUXTYPE=targeted' || return
}

function rpm_not_installed {
  # Check that the supplied rpm $1 is not installed
  local rpm="${1}"
  rpm -q ${rpm} | grep -q "package ${rpm} is not installed" || return
}

function unconfined_procs {
  # Test for unconfined daemons
  local ps_out
  ps_out="$(ps -eZ | egrep 'initrc|unconfined' | egrep -v 'bash|ps|grep')"
  [[ -n "${ps_out}" ]] || return
}

function check_grub_owns {
  # Check User/Group Owner on grub.cfg file
  stat -L -c "%u %g" ${GRUB_CFG} | grep -q '0 0' || return
}

function check_grub_perms {
  # Check Perms on grub.cfg file
  stat -L -c "%a" ${GRUB_CFG} | grep -q '.00' || return
}

function check_file_perms {
  # Check Perms on a supplied file match supplied pattern
  local file="${1}"
  local pattern="${2}"

  stat -L -c "%a" ${file} | grep -q "${pattern}" || return
}

function check_root_owns {
  # Check User/Group Owner on the specified file
  local file="${1}"
  stat -L -c "%u %g" ${file} | grep -q '0 0' || return
}

function check_boot_pass {
  grep -q 'set superusers=' "${GRUB_CFG}"
  if [[ "$?" -ne 0 ]]; then
    grep -q 'set superusers=' ${GRUB_DIR}/* || return
    file="$(grep 'set superusers' ${GRUB_DIR}/* | cut -d: -f1)"
    grep -q 'password' "${file}" || return
  else
    grep -q 'password' "${GRUB_CFG}" || return
  fi
}

function check_svc_not_enabled {
  # Verify that the service $1 is not enabled
  local service="$1" 
  systemctl list-unit-files | grep -qv "${service}" && return 
  systemctl is-enabled "${service}" | grep -q 'enabled' || return
}

function check_svc_enabled {
  # Verify that the service $1 is enabled
  local service="$1" 
  systemctl list-unit-files | grep -q "${service}.service" || return 
  systemctl is-enabled "${service}" | grep -q 'enabled' && return
}

function ntp_cfg {
  cut -d\# -f1 ${NTP_CONF} | egrep "restrict{1}[[:space:]]+default{1}" ${NTP_CONF} | grep kod \
| grep nomodify | grep notrap | grep nopeer | grep -q noquery || return

  cut -d\# -f1 ${NTP_CONF} | egrep "restrict{1}[[:space:]]+\-6{1}[[:space:]]+default" | grep kod \
| grep nomodify | grep notrap | grep nopeer | grep -q noquery || return

  cut -d\# -f1 ${NTP_CONF} | egrep -q "^[[:space:]]*server" || return

  cut -d\# -f1 ${SYSCON_NTPD} | grep "OPTIONS=" | grep -q "ntp:ntp" || return
}

function restrict_core_dumps {
  # Verify that suid programs cannot dump their core
  egrep -q "\*{1}[[:space:]]+hard[[:space:]]+core[[:space:]]+0" "${LIMITS_CNF}" || return
  cut -d\# -f1 ${SYSCTL_CNF} | grep fs.suid_dumpable | cut -d= -f2 | tr -d '[[:space:]]' | grep -q '0' || return 
}

function chk_sysctl_cnf {
  # Check the sysctl_conf file contains a particular flag, set to a particular value 
  local flag="$1"
  local value="$2"
  local sysctl_cnf="$3"

  cut -d\# -f1 ${sysctl_cnf} | grep "${flag}" | cut -d= -f2 | tr -d '[[:space:]]' | grep -q "${value}" || return
}


function chk_sysctl {
  local flag="$1"
  local value="$2"

  sysctl "${flag}" | cut -d= -f2 | tr -d '[[:space:]]' | grep -q "${value}" || return
}

function chk_latest_rel {
  grep -q "${LATEST_REL_STR}" "${CENTOS_REL}" || return
}

function sticky_wrld_w_dirs {
  dirs="$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \
\( -perm -0002 -a ! -perm -1000 \))"
  [[ -z "${dirs}" ]] || return
}

function check_umask {
  cut -d\# -f1 /etc/sysconfig/init | grep -q "umask[[:space:]]027" || return
}

function check_def_tgt {
  #Check that the default boot target is multi-user.target 
  local default_tgt
  default_tgt="$(systemctl get-default)"
  [[ "${default_tgt}" = "multi-user.target" ]] || return
}

function mta_local_only {
  # If port 25 is being listened on, check it is on the loopback address
  netstat_out="$(netstat -an | grep "LIST" | grep ":25[[:space:]]")"
  if [[ "$?" -eq 0 ]] ; then
    ip=$(echo ${netstat_out} | cut -d: -f1 | cut -d" " -f4)
    [[ "${ip}" = "127.0.0.1" ]] || return    
  fi
}

function ip6_router_advertisements_dis {
  # Check that IPv6 Router Advertisements are disabled
  # If ipv6 is disabled then we don't mind what IPv6 router advertisements are set to
  # If ipv6 is enabled then both settings should be set to zero
  chk_sysctl net.ipv6.conf.all.disable_ipv6 1 && return
  chk_sysctl net.ipv6.conf.all.accept_ra 0 || return
  chk_sysctl net.ipv6.conf.default.accept_ra 0 || return
}
  
function ip6_redirect_accept_dis {
  # Check that IPv6 Redirect Acceptance is disabled
  # If ipv6 is disabled then we don't mind what IPv6 redirect acceptance is set to
  # If ipv6 is enabled then both settings should be set to zero
  chk_sysctl net.ipv6.conf.all.disable_ipv6 1 && return
  chk_sysctl net.ipv6.conf.all.accept_redirects 0 || return
  chk_sysctl net.ipv6.conf.default.accept_redirects 0 || return
}

function chk_file_exists {
  local file="$1"
  [[ -f "${file}" ]] || return
}
 
function chk_hosts_deny_content {
  # Check the hosts.deny file resembles ALL: ALL
  cut -d\# -f1 ${HOSTS_DENY} | grep -q "ALL[[:space:]]*:[[:space:]]*ALL" || return
}

function chk_cis_cnf { 
  local protocol="$1"
  local file="$2"
  grep -q "install[[:space:]]${protocol}[[:space:]]/bin/true" ${file} || return
} 

function chk_rsyslog_content {
  # rsyslog should be configured to send logs to a remote host
  # grep output should resemble 
  # *.* @@loghost.example.com
  grep -q "^*.*[^I][^I]*@" ${RSYSLOG_CNF} || return
}

function audit_log_storage_size {
  # Check the max size of the audit log file is configured
  cut -d\# -f1 ${AUDITD_CNF} | egrep -q "max_log_file[[:space:]]|max_log_file=" || return
}


function dis_on_audit_log_full {
  # Check auditd.conf is configured to notify the admin and halt the system when audit logs are full
  cut -d\# -f2 ${AUDITD_CNF} | grep 'space_left_action' | cut -d= -f2 | tr -d '[[:space:]]' | grep -q 'email' || return
  cut -d\# -f2 ${AUDITD_CNF} | grep 'action_mail_acct' | cut -d= -f2 | tr -d '[[:space:]]' | grep -q 'root' || return
  cut -d\# -f2 ${AUDITD_CNF} | grep 'admin_space_left_action' | cut -d= -f2 | tr -d '[[:space:]]' | grep -q 'halt' || return
}

function keep_all_audit_info {
  # Check auditd.conf is configured to retain audit logs
  cut -d\# -f2 ${AUDITD_CNF} | grep 'max_log_file_action' | cut -d= -f2 | tr -d '[[:space:]]' | grep -q 'keep_logs' || return
}

function audit_procs_prior_2_auditd {
  # Check lines that start with linux have the audit=1 parameter set
  grep_grub="$(grep "^[[:space:]]*linux" ${GRUB_CFG} | grep -v 'audit=1')"
  [[ -z "${grep_grub}" ]] || return
}

function audit_date_time {
  # Confirm that the time-change lines specified below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+time-change" | egrep "\-S[[:space:]]+settimeofday" \
  | egrep "\-S[[:space:]]+adjtimex" | egrep "\-F[[:space:]]+arch=b64" | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+time-change" | egrep "\-S[[:space:]]+settimeofday" \
  | egrep "\-S[[:space:]]+adjtimex" | egrep "\-F[[:space:]]+arch=b32" | egrep "\-S[[:space:]]+stime" | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+time-change" | egrep "\-F[[:space:]]+arch=b64" \
  | egrep "\-S[[:space:]]+clock_settime" | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+time-change" | egrep "\-F[[:space:]]+arch=b32" \
  | egrep "\-S[[:space:]]+clock_settime" | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+time-change" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/localtime" || return
}

function audit_user_group {
  # Confirm that the identity lines specified below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+identity" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/group" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+identity" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/passwd" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+identity" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/gshadow" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+identity" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/shadow" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+identity" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/security\/opasswd" || return
}

function audit_network_env {
  # Confirm that the system-locale lines specified below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+system-locale" | egrep "\-S[[:space:]]+sethostname" \
  | egrep "\-S[[:space:]]+setdomainname" | egrep "\-F[[:space:]]+arch=b64" | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+system-locale" | egrep "\-S[[:space:]]+sethostname" \
  | egrep "\-S[[:space:]]+setdomainname" | egrep "\-F[[:space:]]+arch=b32" | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+system-locale" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/issue" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+system-locale" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/issue.net" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+system-locale" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/hosts" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+system-locale" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/sysconfig\/network" || return
}

function audit_logins_logouts {
  # Confirm that the logins lines specified below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+logins" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/log\/faillog" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+logins" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/log\/lastlog" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+logins" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/log\/tallylog" || return
}

function audit_session_init {
  # Confirm that the logins lines specified below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+session" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/run\/utmp" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+session" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/log\/wtmp" || return
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+session" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/log\/btmp" || return
}

function audit_sys_mac {
  # Confirm that the logins lines specified below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+MAC-policy" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/selinux\/" || return
}

function audit_dac_perm_mod_events {
  # Confirm that perm_mod lines matching the patterns below do appear in the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+perm_mod" | egrep "\-S[[:space:]]+chmod" \
  | egrep "\-S[[:space:]]+fchmod" | egrep "\-S[[:space:]]+fchmodat" | egrep "\-F[[:space:]]+arch=b64" \
  | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+perm_mod" | egrep "\-S[[:space:]]+chmod" \
  | egrep "\-S[[:space:]]+fchmod" | egrep "\-S[[:space:]]+fchmodat" | egrep "\-F[[:space:]]+arch=b32" \
  | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+perm_mod" | egrep "\-S[[:space:]]+chown" \
  | egrep "\-S[[:space:]]+fchown" | egrep "\-S[[:space:]]+fchownat" | egrep "\-S[[:space:]]+fchown" \
  | egrep "\-F[[:space:]]+arch=b64" | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+perm_mod" | egrep "\-S[[:space:]]+chown" \
  | egrep "\-S[[:space:]]+fchown" | egrep "\-S[[:space:]]+fchownat" | egrep "\-S[[:space:]]+fchown" \
  | egrep "\-F[[:space:]]+arch=b32" | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+perm_mod" | egrep "\-S[[:space:]]+setxattr" \
  | egrep "\-S[[:space:]]+lsetxattr" | egrep "\-S[[:space:]]+fsetxattr" | egrep "\-S[[:space:]]+removexattr" \
  | egrep "\-S[[:space:]]+lremovexattr" | egrep "\-S[[:space:]]+fremovexattr" | egrep "\-F[[:space:]]+arch=b64" \
  | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+perm_mod" | egrep "\-S[[:space:]]+setxattr" \
  | egrep "\-S[[:space:]]+lsetxattr" | egrep "\-S[[:space:]]+fsetxattr" | egrep "\-S[[:space:]]+removexattr" \
  | egrep "\-S[[:space:]]+lremovexattr" | egrep "\-S[[:space:]]+fremovexattr" | egrep "\-F[[:space:]]+arch=b32" \
  | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
}

function unsuc_unauth_acc_attempts {
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+access" | egrep "\-S[[:space:]]+creat" \
  | egrep "\-S[[:space:]]+open" | egrep "\-S[[:space:]]+openat" | egrep "\-S[[:space:]]+truncate" \
  | egrep "\-S[[:space:]]+ftruncate" | egrep "\-F[[:space:]]+arch=b64" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" | egrep "\-F[[:space:]]exit=\-EACCES" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+access" | egrep "\-S[[:space:]]+creat" \
  | egrep "\-S[[:space:]]+open" | egrep "\-S[[:space:]]+openat" | egrep "\-S[[:space:]]+truncate" \
  | egrep "\-S[[:space:]]+ftruncate" | egrep "\-F[[:space:]]+arch=b32" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" | egrep "\-F[[:space:]]exit=\-EACCES" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+access" | egrep "\-S[[:space:]]+creat" \
  | egrep "\-S[[:space:]]+open" | egrep "\-S[[:space:]]+openat" | egrep "\-S[[:space:]]+truncate" \
  | egrep "\-S[[:space:]]+ftruncate" | egrep "\-F[[:space:]]+arch=b64" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" | egrep "\-F[[:space:]]exit=\-EPERM" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+access" | egrep "\-S[[:space:]]+creat" \
  | egrep "\-S[[:space:]]+open" | egrep "\-S[[:space:]]+openat" | egrep "\-S[[:space:]]+truncate" \
  | egrep "\-S[[:space:]]+ftruncate" | egrep "\-F[[:space:]]+arch=b32" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" | egrep "\-F[[:space:]]exit=\-EPERM" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

}

function coll_priv_cmds {
  local priv_cmds
  priv_cmds="$(find / -xdev \( -perm -4000 -o -perm -2000 \) -type f)"
  for cmd in ${priv_cmds} ; do
    cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+privileged" | egrep "\-F[[:space:]]+path=${cmd}" \
    | egrep "\-F[[:space:]]+perm=x" | egrep "\-F[[:space:]]+auid>=1000" | egrep "\-F[[:space:]]+auid\!=4294967295" \
    | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
  done
}

function coll_suc_fs_mnts {
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+mounts" | egrep "\-S[[:space:]]+mount" \
  | egrep "\-F[[:space:]]+arch=b64" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+mounts" | egrep "\-S[[:space:]]+mount" \
  | egrep "\-F[[:space:]]+arch=b32" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
}

function coll_file_del_events {
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+delete" | egrep "\-S[[:space:]]+unlink" \
  | egrep "\-F[[:space:]]+arch=b64" | egrep "\-S[[:space:]]+unlinkat" | egrep "\-S[[:space:]]+rename" \
  | egrep "\-S[[:space:]]+renameat" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+delete" | egrep "\-S[[:space:]]+unlink" \
  | egrep "\-F[[:space:]]+arch=b32" | egrep "\-S[[:space:]]+unlinkat" | egrep "\-S[[:space:]]+rename" \
  | egrep "\-S[[:space:]]+renameat" | egrep "\-F[[:space:]]+auid>=1000" \
  | egrep "\-F[[:space:]]+auid\!=4294967295" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return

}

function coll_chg2_sysadm_scope {
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+scope" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/etc\/sudoers" || return

}

function coll_sysadm_actions {
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+actions" | egrep "\-p[[:space:]]+wa" \
  | egrep -q "\-w[[:space:]]+\/var\/log\/sudo.log" || return

}

function kmod_lod_unlod {
  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+modules" | egrep "\-p[[:space:]]+x" \
  | egrep -q "\-w[[:space:]]+\/sbin\/insmod" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+modules" | egrep "\-p[[:space:]]+x" \
  | egrep -q "\-w[[:space:]]+\/sbin\/rmmod" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+modules" | egrep "\-p[[:space:]]+x" \
  | egrep -q "\-w[[:space:]]+\/sbin\/modprobe" || return

  cut -d\# -f1 ${AUDIT_RULES} | egrep "\-k[[:space:]]+modules" | egrep "\-S[[:space:]]+delete_module" \
  | egrep "\-F[[:space:]]+arch=b64" | egrep "\-S[[:space:]]+init_module" \
  | egrep -q "\-a[[:space:]]+always,exit|\-a[[:space:]]+exit,always" || return
}

function audit_cfg_immut {
  # There should be a "-e 2" at the end of the audit.rules file
  cut -d\# -f1 ${AUDIT_RULES} | egrep -q "^-e[[:space:]]+2" || return
}

function logrotate_cfg {
  [[ -f "${LOGR_SYSLOG}" ]] || return

  local timestamp
  timestamp=$(date '+%Y%m%d_%H%M%S')
  local tmp_data="/tmp/logrotate.tmp.${timestamp}"
  local file_list="/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron"
  local line_num
  line_num=$(grep -n '{' "${LOGR_SYSLOG}" | cut -d: -f1)
  line_num=$((${line_num} - 1))
  head -${line_num} "${LOGR_SYSLOG}" > ${tmp_data}
  for file in ${file_list} ; do
    grep -q "${file}" ${tmp_data} || return
  done
  rm "${tmp_data}" 
}

function atd_cfg {
 [[ ! -f ${AT_DENY} ]] || return 
 [[ -f ${AT_ALLOW} ]] || return 
 check_root_owns "${AT_ALLOW}"
 check_file_perms "${AT_ALLOW}" 600 
}

function at_cron_auth_users {
 [[ ! -f ${AT_DENY} ]] || return 
 [[ ! -f ${CRON_DENY} ]] || return 
 check_root_owns "${CRON_ALLOW}"
 check_root_owns "${AT_ALLOW}"
 check_file_perms "${CRON_ALLOW}" 600 
 check_file_perms "${AT_ALLOW}" 600 
}

function chk_param {
  local file="${1}" 
  local parameter="${2}" 
  local value="${3}" 
  cut -d\# -f1 ${file} | egrep -q "^${parameter}[[:space:]]+${value}" || return
}


function ssh_maxauthtries {
  local allowed_max="${1}"
  local actual_value
  actual_value=$(cut -d\# -f1 ${SSHD_CFG} | grep 'MaxAuthTries' | cut -d" " -f2)
  [[ ${actual_value} -le ${allowed_max} ]] || return 
}

function ssh_access {
  local allow_users
  local allow_groups
  local deny_users
  local deny_users
  allow_users="$(cut -d\# -f1 ${SSHD_CFG} | grep "AllowUsers" | cut -d" " -f2)"
  allow_groups="$(cut -d\# -f1 ${SSHD_CFG} | grep "AllowGroups" | cut -d" " -f2)"
  deny_users="$(cut -d\# -f1 ${SSHD_CFG} | grep "DenyUsers" | cut -d" " -f2)"
  deny_groups="$(cut -d\# -f1 ${SSHD_CFG} | grep "DenyGroups" | cut -d" " -f2)"
  [[ -n "${allow_users}" ]] || return
  [[ -n "${allow_groups}" ]] || return
  [[ -n "${deny_users}" ]] || return
  [[ -n "${deny_groups}" ]] || return
}

function pass_hash_algo {
  local algo="${1}"
  authconfig --test | grep 'hashing' | grep -q "${algo}" || return
}

function pass_req_params {
  # verify the pam_pwquality.so params in /etc/pam.d/system-auth
  grep pam_pwquality.so ${SYSTEM_AUTH} | grep 'password' | grep 'requisite' | grep 'try_first_pass' | grep 'local_users_only' | grep 'retry=3' | grep -q 'authtok_type=' || return
  grep -q 'minlen=14' ${PWQUAL_CNF} || return
  grep -q 'dcredit=-1' ${PWQUAL_CNF} || return
  grep -q 'ucredit=-1' ${PWQUAL_CNF} || return
  grep -q 'ocredit=-1' ${PWQUAL_CNF} || return
  grep -q 'lcredit=-1' ${PWQUAL_CNF} || return
}

function failed_pass_lock {
 egrep "auth[[:space:]]+required" ${PASS_AUTH} | grep -q 'pam_deny.so' || return
 egrep "auth[[:space:]]+required" ${PASS_AUTH} | grep 'pam_faillock.so' | grep 'preauth' | grep 'audit' | grep 'silent' | grep 'deny=5' | grep -q 'unlock_time=900' || return
 grep 'auth' ${PASS_AUTH} | grep 'pam_unix.so' | egrep -q "\[success=1[[:space:]]+default=bad\]" || return
 grep 'auth' ${PASS_AUTH} | grep 'pam_faillock.so' | grep 'authfail' | grep 'audit' | grep 'deny=5' | grep 'unlock_time=900' | egrep -q "\[default=die\]" || return
 egrep "auth[[:space:]]+sufficient" ${PASS_AUTH} | grep 'pam_faillock.so' | grep 'authsucc' | grep 'audit' | grep 'deny=5' | grep -q 'unlock_time=900' || return
 egrep "auth[[:space:]]+required" ${PASS_AUTH} | grep -q 'pam_deny.so' || return

 egrep "auth[[:space:]]+required" ${SYSTEM_AUTH} | grep -q 'pam_env.so' || return
 egrep "auth[[:space:]]+required" ${SYSTEM_AUTH} | grep 'pam_faillock.so' | grep 'preauth' | grep 'audit' | grep 'silent' | grep 'deny=5' | grep -q 'unlock_time=900' || return
 grep 'auth' ${SYSTEM_AUTH} | grep 'pam_unix.so' | egrep -q "\[success=1[[:space:]]+default=bad\]" || return
 grep 'auth' ${SYSTEM_AUTH} | grep 'pam_faillock.so' | grep 'authfail' | grep 'audit' | grep 'deny=5' | grep 'unlock_time=900' | egrep -q "\[default=die\]" || return
 egrep "auth[[:space:]]+sufficient" ${SYSTEM_AUTH} | grep 'pam_faillock.so' | grep 'authsucc' | grep 'audit' | grep 'deny=5' | grep -q 'unlock_time=900' || return
 egrep "auth[[:space:]]+required" ${SYSTEM_AUTH} | grep -q 'pam_deny.so' || return
}

function lim_passwd_reuse {
 egrep "auth[[:space:]]+sufficient" ${SYSTEM_AUTH} | grep 'pam_unix.so' | grep -q 'remember=5' || return
}

function su_access {
  egrep "auth[[:space:]]+required" "${PAM_SU}" | grep 'pam_wheel.so' | grep -q 'use_uid' || return
  grep 'wheel' "${GROUP}" | cut -d: -f4 | grep -q 'root' || return
}

function dis_sys_accs {
  # Check that system accounts are disabled
  local accounts 
  accounts="$(egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" \
&& $1!="halt" && $3<1000 && $7!="/sbin/nologin") {print}')"
  [[ -z "${accounts}" ]] || return
}

function root_def_grp {
  local gid1
  local gid2
  gid1="$(grep "^root:" "${PASSWD}" | cut -d: -f4)" 
  [[ "${gid1}" -eq 0 ]] || return
  gid2="$(id -g root)" 
  [[ "${gid2}" -eq 0 ]] || return
}

function def_umask_for_users {
  cut -d\#  -f1 "${BASHRC}" | egrep -q "umask[[:space:]]+077" || return
  egrep -q "umask[[:space:]]+077" ${PROF_D}/* || return
}

function inactive_usr_acs_locked {
  # After being inactive for a period of time the account should be disabled
  local days
  local inactive_threshold=35
  days="$(useradd -D | grep INACTIVE | cut -d= -f2)"
  [[ ${days} -ge ${inactive_threshold} ]] || return
}

function warning_banners {
  # Check that system login banners don't contain any OS information
  local motd
  local issue
  local issue_net
  motd="$(egrep '(\\v|\\r|\\m|\\s)' ${MOTD})"
  issue="$(egrep '(\\v|\\r|\\m|\\s)' ${ISSUE})"
  issue_net="$(egrep '(\\v|\\r|\\m|\\s)' ${ISSUE_NET})"
  [[ -z "${motd}" ]] || return
  [[ -z "${issue}" ]] || return
  [[ -z "${issue_net}" ]] || return
}

function gnome_banner {
  # On a host aiming to meet CIS requirements GNOME is unlikely to be installed 
  # Thus the function says if the file exists then it should have these lines in it
  if [[ -f "${BANNER_MSG}" ]] ; then
    egrep '[org/gnome/login-screen]' ${BANNER_MSG} || return
    egrep 'banner-message-enable=true' ${BANNER_MSG} || return
    egrep 'banner-message-text=' ${BANNER_MSG} || return
  fi
}

function unowned_files {
  local uo_files
  uo_files="$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser)"
  [[ -z "${uo_files}" ]] || return
}
 

function ungrouped_files {
  local ug_files
  ug_files="$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup)"
  [[ -z "${ug_files}" ]] || return
}

function suid_exes {
  # For every suid exe on the host use the rpm cmd to verify that it should be suid executable
  # If the rpm cmd returns no output then the rpm is as it was when it was installed so no prob
  local suid_exes
  suid_exes="$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print)"
  for suid_exe in ${suid_exes}
  do
    rpm_out="$(rpm -V $(rpm -qf ${suid_exe}))"
    [[ -z "${rpm_out}" ]] || return
  done
}
 
function sgid_exes {
  # For every sgid exe on the host use the rpm cmd to verify that it should be sgid executable
  # If the rpm cmd returns no output then the rpm is as it was when it was installed so no prob
  local sgid_exes
  sgid_exes="$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print)"
  for sgid_exe in ${sgid_exes}
  do
    rpm_out="$(rpm -V $(rpm -qf ${sgid_exe}))"
    [[ -z "${rpm_out}" ]] || return
  done
}

function passwd_field_chk {
  local shadow_out
  shadow_out="$(awk -F: '($2 == "" ) { print $1 }' ${SHADOW})"
  [[ -z "${shadow_out}" ]] || return
}

function nis_in_file {
  # Check for lines starting with + in the supplied file $1 
  # In /etc/{passwd,shadow,group} it used to be a marker to insert data from NIS 
  # There shouldn't be any entries like this
  local file="${1}"
  local grep_out
  grep_out="$(grep '^+:' ${file})"
  [[ -z "${grep_out}" ]] || return
}

function no_uid0_other_root {
  local grep_passwd
  grep_passwd="$(awk -F: '($3 == 0) { print $1 }' ${PASSWD})"
  [[ "${grep_passwd}" = "root" ]] || return  
}

function world_w_dirs {
  dirs="$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002)"
  [[ -z "${dirs}" ]] || return   
}

function root_path {
  # There should not be an empty dir in $PATH
  local grep=/bin/grep
  local sed=/bin/sed
  path_grep="$(echo ${PATH} | ${grep} '::')"
  [[ -z "${path_grep}" ]] || return 

  # There should not be a trailing : on $PATH
  path_grep="$(echo ${PATH} | ${grep} :$)"
  [[ -z "${path_grep}" ]] || return 

  path_dirs="$(echo $PATH | ${sed} -e 's/::/:/' -e 's/:$//' -e 's/:/ /g')"
  for dir in ${path_dirs} ; do
    # PATH should not contain .
    [[ "${dir}" != "." ]] || return

    #$dir should be a directory
    [[ -d "${dir}" ]] || return

    local ls_out
    ls_out="$(ls -ldH ${dir})" 
    if is_group_writable ${ls_out} ; then return 1 ; else return 0 ; fi
    if is_other_writable ${ls_out} ; then return 1 ; else return 0 ; fi


    # Directory should be owned by root
    dir_own="$(echo ${ls_out} | awk '{print $3}')"
    [[ "${dir_own}" = "root" ]] || return
  done
}

function is_group_readable {
  local ls_output="${1}"
  # 5th byte of ls output is the field for group readable
  [[ "${ls_output:4:1}" = "r" ]] || return
}

function is_group_writable {
  local ls_output="${1}"
  # 6th byte of ls output is the field for group writable
  [[ "${ls_output:5:1}" = "w" ]] || return
}

function is_group_executable {
  local ls_output="${1}"
  # 7th byte of ls output is the field for group readable
  [[ "${ls_output:6:1}" = "r" ]] || return
}

function is_other_readable {
  local ls_output="${1}"
  # 8th byte of ls output is the field for other readable
  [[ "${ls_output:7:1}" = "r" ]] || return
}

function is_other_writable {
  local ls_output="${1}"
  # 9th byte of ls output is the field for other writable
  [[ "${ls_output:8:1}" = "w" ]] || return
}

function is_other_executable {
  local ls_output="${1}"
  # 10th byte of ls output is the field for other executable
  [[ "${ls_output:9:1}" = "x" ]] || return
}
 
function home_dir_perms {
  dirs="$(grep -v 'root|halt|sync|shutdown' ${PASSWD} | awk -F: '($7 != "/sbin/nologin") { print $6 }')"
  [[ -z "${dirs}" ]] && return
  for dir in ${dirs} ; do
    [[ -d "${dir}" ]] || continue
    local ls_out
    ls_out="$(ls -ldH ${dir})"
    if is_group_writable ${ls_out} ; then return 1 ; else return 0 ; fi
    if is_other_readable ${ls_out} ; then return 1 ; else return 0 ; fi
    if is_other_writable ${ls_out} ; then return 1 ; else return 0 ; fi
    if is_other_executable ${ls_out} ; then return 1 ; else return 0 ; fi
  done
}
 
function dot_file_perms {
  dirs="$(grep -v 'root|halt|sync|shutdown' ${PASSWD} | awk -F: '($7 != "/sbin/nologin") { print $6 }')"
  for dir in ${dirs} ; do
    [[ -d "${dir}" ]] || continue
    for file in ${dir}/.[A-Za-z0-9]* ; do
      if [[ ! -h "${file}" && -f "${file}" ]] ; then
        local ls_out
        ls_out="$(ls -ldH ${dir})"
        if is_group_writable ${ls_out} ; then return 1 ; else return 0 ; fi 
        if is_other_writable ${ls_out} ; then return 1 ; else return 0 ; fi
      fi 
    done
  done
}

function dot_rhosts_files {
  dirs="$(grep -v 'root|halt|sync|shutdown' ${PASSWD} | awk -F: '($7 != "/sbin/nologin") { print $6 }')"
  for dir in ${dirs} ; do
    [[ -d "${dir}" ]] || continue
    local file="${dir}/.rhosts"
    if [[ ! -h "${file}" && -f "${file}" ]] ; then
      return 1
    else
      return 0
    fi
  done
}

function chk_groups_passwd {
  # We don't want to see any groups in /etc/passwd that aren't in /etc/group
  group_ids="$(cut -s -d: -f4 ${PASSWD} | sort -u)"
  for group_id in ${group_ids} ; do
    grep -q -P "^.*?:x:${group_id}:" ${GROUP} || return
  done
}

function chk_home_dirs_exist {
  #Check that users home directory do all exist
  while read user uid dir ; do
    if [[ "${uid}" -ge 1000 && ! -d "${dir}" && "${user}" != "nfsnobody" ]] ; then
      return 1 
    fi
  done < <(awk -F: '{ print $1 " " $3 " " $6 }' ${PASSWD})
}

function chk_home_dirs_owns {
  #Check that users home directory do all exist
  while read user uid dir ; do
    if [[ "${uid}" -ge 1000 && ! -d "${dir}" && "${user}" != "nfsnobody" ]] ; then
      local owner
      owner="$(stat -L -c "%U" "${dir}")"
      [[ "${owner}" = "${user}" ]] || return
    fi
  done < <(awk -F: '{ print $1 " " $3 " " $6 }' ${PASSWD})
}

function dot_netrc_perms {
  dirs="$(grep -v 'root|halt|sync|shutdown' ${PASSWD} | awk -F: '($7 != "/sbin/nologin") { print $6 }')"
  for dir in ${dirs} ; do
    [[ -d "${dir}" ]] || continue
    for file in ${dir}/.netrc ; do
      if [[ ! -h "${file}" && -f "${file}" ]] ; then
        local ls_out
        ls_out="$(ls -ldH ${dir})"
        if is_group_readable ${ls_out} ; then return 1 ; else return 0 ; fi 
        if is_group_writable ${ls_out} ; then return 1 ; else return 0 ; fi
        if is_group_executable ${ls_out} ; then return 1 ; else return 0 ; fi
        if is_other_readable ${ls_out} ; then return 1 ; else return 0 ; fi 
        if is_other_writable ${ls_out} ; then return 1 ; else return 0 ; fi
        if is_other_executable ${ls_out} ; then return 1 ; else return 0 ; fi
      fi 
    done
  done
}

function user_dot_netrc {
  # We don't want to see any ~/.netrc files
  local dirs
  dirs="$(cut -d: -f6 ${PASSWD})" 
  for dir in ${dirs} ; do
    [[ -d "${dir}" ]] || continue
    if [[ ! -h "${dir}/.netrc" && -f "${dir}/.netrc" ]] ; then
      return 1 
    fi
  done
}

function user_dot_forward {
  # We don't want to see any ~/.forward files
  local dirs
  dirs="$(cut -d: -f6 ${PASSWD})" 
  for dir in ${dirs} ; do
    [[ -d "${dir}" ]] || continue
    if [[ ! -h "${dir}/.forward" && -f "${dir}/.forward" ]] ; then
      return 1 
    fi
  done
}

function duplicate_uids {
  local num_of_uids
  local uniq_num_of_uids
  num_of_uids="$(cut -f3 -d":" ${PASSWD} | wc -l)"
  uniq_num_of_uids="$(cut -f3 -d":" ${PASSWD} | sort -n | uniq | wc -l)" 
  [[ "${num_of_uids}" -eq "${uniq_num_of_uids}" ]] || return
}

function duplicate_gids {
  local num_of_gids
  local uniq_num_of_gids
  num_of_gids="$(cut -f3 -d":" ${GROUP} | wc -l)"
  uniq_num_of_gids="$(cut -f3 -d":" ${GROUP} | sort -n | uniq | wc -l)" 
  [[ "${num_of_gids}" -eq "${uniq_num_of_gids}" ]] || return
}

function chk_uids_4_res {
  local default_users='root bin daemon adm lp sync shutdown halt mail news uucp operator games \
gopher ftp nobody nscd vcsa rpc mailnull smmsp pcap ntp dbus avahi sshd rpcuser \ 
nfsnobody haldaemon avahi-autoipd distcache apache oprofile webalizer dovecot squid \
named xfs gdm sabayon usbmuxd rtkit abrt saslauth pulse postfix tcpdump polkitd tss chrony'
  while read user uid; do
    local found=0
    for duser in ${default_users} ; do
      if [[ "${user}" = "${duser}" ]] ; then
        found=1
      fi
    done
    [[ "${found}" -eq 1 ]] || return
  done < <(awk -F: '($3 < 1000) {print $1" "$3 }' ${PASSWD}) 
}

function duplicate_usernames {
  local num_of_usernames
  local num_of_uniq_usernames
  num_of_usernames="$(cut -f1 -d":" ${PASSWD} | wc -l)"
  num_of_uniq_usernames="$(cut -f1 -d":" ${PASSWD} | sort | uniq | wc -l)" 
  [[ "${num_of_usernames}" -eq "${num_of_uniq_usernames}" ]] || echo Passed
}

function duplicate_groupnames {
  local num_of_groupnames
  local num_of_uniq_groupnames
  num_of_groupnames="$(cut -f1 -d":" ${GROUP} | wc -l)"
  num_of_uniq_groupnames="$(cut -f1 -d":" ${GROUP} | sort | uniq | wc -l)" 
  [[ "${num_of_groupnames}" -eq "${num_of_uniq_groupnames}" ]] || echo Passed
}

function func_wrapper {
  func_name=$1
  shift
  args=$@
  ${func_name} ${args}
  if [[ "$?" -eq 0 ]]; then
    echo ${func_name} ${args} Passed 
  else
    echo ${func_name} ${args} Failed 
  fi
}


function main {

  # CIS 1.1.1 Test that there is a separate /tmp partition
  func_wrapper separate_partition /tmp
  
  # CIS 1.1.2 Test that the nodev option is on the /tmp partition
  func_wrapper mount_option /tmp nodev

  # CIS 1.1.3 Test that the nosuid option is on the /tmp partition
  func_wrapper mount_option /tmp nosuid

  # CIS 1.1.4 Test that the noexec option is on the /tmp partition
  func_wrapper mount_option /tmp noexec

  # CIS 1.1.5 Test that there is a separate /var partition
  func_wrapper separate_partition /var

  # CIS 1.1.6 Test that the /var/tmp directory is bind mounted onto the /tmp filesystem
  func_wrapper bind_mounted_to /var/tmp /tmp

  # CIS 1.1.7 Test that there is a separate /var/log partition
  func_wrapper separate_partition /var/log

  # CIS 1.1.8 Test that there is a separate /var/log/audit partition
  func_wrapper separate_partition /var/log/audit

  # CIS 1.1.9 Test that there is a separate /home partition
  func_wrapper separate_partition /home

  # CIS 1.1.10 Test that the nodev option is on the /home partition
  func_wrapper mount_option /home nodev

  # TO DO CIS 1.1.11 nodev option on removable media partitions
  # TO DO CIS 1.1.12 noexec option on removable media partitions
  # TO DO CIS 1.1.13 nosuid option on removable media partitions

  # CIS 1.1.14 Test that the nodev option is on the /dev/shm partition
  func_wrapper mount_option /dev/shm nodev

  # CIS 1.1.15 Test that the nosuid option is on the /dev/shm partition
  func_wrapper mount_option /dev/shm nosuid

  # CIS 1.1.16 Test that the noexec option is on the /dev/shm partition
  func_wrapper mount_option /dev/shm noexec

  # TO DO CIS 1.1.17 Check for the sticky bit on all world writable dirs
  func_wrapper sticky_wrld_w_dirs 

  # CIS 1.1.18 Test that the mounting of cramfs filesystems is disabled  
  func_wrapper test_disable_mounting cramfs
  
  # CIS 1.1.19 Test that the mounting of freevxfs filesystems is disabled  
  func_wrapper test_disable_mounting freevxfs

  # CIS 1.1.20 Test that the mounting of jffs2 filesystems is disabled  
  func_wrapper test_disable_mounting jffs2

  # CIS 1.1.21 Test that the mounting of hfs filesystems is disabled  
  func_wrapper test_disable_mounting hfs

  # CIS 1.1.22 Test that the mounting of hfsplus filesystems is disabled  
  func_wrapper test_disable_mounting hfsplus

  # CIS 1.1.23 Test that the mounting of squashfs filesystems is disabled  
  func_wrapper test_disable_mounting squashfs

  # CIS 1.1.24 Test that the mounting of udf filesystems is disabled  
  func_wrapper test_disable_mounting udf

  # CIS 1.2.1 Check that the CentOS GPG Key is Installed
  func_wrapper centos_gpg_key_installed

  # CIS 1.2.2 Check that gpgcheck is globally activated
  func_wrapper yum_gpgcheck

  # CIS 1.2.3 Check software package updates with yum
  func_wrapper yum_update
  
  # CIS 1.2.4 Verify package integrity using RPM
  func_wrapper pkg_integrity
  
  # CIS 1.3.1 Check that the AIDE rpm is installed
  func_wrapper rpm_installed aide
  
  # CIS 1.3.2 Check periodic execution of file integrity (that aide runs from cron)
  func_wrapper verify_aide_cron

  # CIS 1.4.1 Check that SELinux is not disabled in /boot/grub2/grub.cfg 
  func_wrapper verify_selinux_grubcfg

  # CIS 1.4.2 Verify SELinux configured state in /etc/selinux/config
  func_wrapper verify_selinux_state

  # CIS 1.4.3 Verify SELinux policy in /etc/selinux/config
  func_wrapper verify_selinux_policy

  # CIS 1.4.4 Check setroubleshoot RPM is not installed
  func_wrapper rpm_not_installed setroubleshoot 

  # CIS 1.4.5 Check setroubleshoot RPM is not installed
  func_wrapper rpm_not_installed mcstrans 

  # CIS 1.4.6 Check for unconfined daemons
  func_wrapper unconfined_procs
  
  # CIS 1.5.1 Check ownership on /boot/grub2/grub.cfg
  func_wrapper check_root_owns ${GRUB_CFG}

  # CIS 1.5.2 Check permissions on /boot/grub2/grub.cfg
  func_wrapper check_grub_perms

  # CIS 1.5.3 Check permissions on /boot/grub2/grub.cfg
  func_wrapper check_boot_pass

  # TO DO CIS 1.6.1
  func_wrapper restrict_core_dumps 

  # CIS 1.6.2 Verify that the flag to force randomized virtual memory region placement is set
  func_wrapper chk_sysctl kernel.randomize_va_space 2

  # TO DO CIS 1.7
  func_wrapper chk_latest_rel

  # CIS 2.1.1 Check telnet-server RPM is not installed
  func_wrapper rpm_not_installed telnet-server

  # CIS 2.1.2 Check telnet RPM is not installed
  func_wrapper rpm_not_installed telnet

  # CIS 2.1.3 Check rsh-server RPM is not installed
  func_wrapper rpm_not_installed rsh-server

  # CIS 2.1.4 Check rsh RPM is not installed
  func_wrapper rpm_not_installed rsh

  # CIS 2.1.5 Check ypbind RPM is not installed
  func_wrapper rpm_not_installed ypbind

  # CIS 2.1.6 Check ypserv RPM is not installed
  func_wrapper rpm_not_installed ypserv

  # CIS 2.1.7 Check tftp RPM is not installed
  func_wrapper rpm_not_installed tftp

  # CIS 2.1.8 Check tftp-server RPM is not installed
  func_wrapper rpm_not_installed tftp-server

  # CIS 2.1.9 Check talk RPM is not installed
  func_wrapper rpm_not_installed talk

  # CIS 2.1.10 Check talk-server RPM is not installed
  func_wrapper rpm_not_installed talk-server

  # CIS 2.1.11 Check xinetd RPM is not installed
  func_wrapper rpm_not_installed xinetd

  # CIS 2.1.12 Check chargen-dgram is not enabled
  func_wrapper check_svc_not_enabled chargen-dgram

  # CIS 2.1.13 Check chargen-stream is not enabled
  func_wrapper check_svc_not_enabled chargen-stream

  # CIS 2.1.14 Check daytime-dgram is not enabled
  func_wrapper check_svc_not_enabled daytime-dgram
  
  # CIS 2.1.15 Check daytime-stream is not enabled
  func_wrapper check_svc_not_enabled daytime-stream

  # CIS 2.1.16 Check echo-dgram is not enabled
  func_wrapper check_svc_not_enabled echo-dgram

  # CIS 2.1.17 Check echo-dgram is not enabled
  func_wrapper check_svc_not_enabled echo-stream

  # CIS 2.1.18 Check tcpmux-server is not enabled
  func_wrapper check_svc_not_enabled tcpmux-server

  # CIS 3.1 Check Daemon umask
  func_wrapper check_umask 

  # TODO CIS 3.2  X Window System
  func_wrapper check_def_tgt

  # CIS 3.2 Check telnet-server RPM is not installed
  func_wrapper rpm_not_installed xorg-x11-server-common

  # CIS 3.3 Check avahi-daemon is not enabled
  func_wrapper check_svc_not_enabled avahi-daemon

  # CIS 3.4 Check cups is not enabled
  func_wrapper check_svc_not_enabled cups

  # CIS 3.5 Check dhcp RPM is not installed
  func_wrapper rpm_not_installed dhcp

  # CIS 3.6 NTP config
  func_wrapper ntp_cfg

  # CIS 3.7.1 Check LDAP RPMs are not installed
  func_wrapper rpm_not_installed openldap-servers
  func_wrapper rpm_not_installed openldap-clients

  # CIS 3.8 Check NFS and RPC are not enabled
  func_wrapper check_svc_not_enabled nfslock
  func_wrapper check_svc_not_enabled rpcgssd
  func_wrapper check_svc_not_enabled rpcbind
  func_wrapper check_svc_not_enabled rpcidmapd
  func_wrapper check_svc_not_enabled rpcsvcgssd

  # CIS 3.9 Check bind RPM is not installed
  func_wrapper rpm_not_installed bind

  # CIS 3.10 Check vsftpd RPM is not installed
  func_wrapper rpm_not_installed vsftpd

  # CIS 3.11 Check httpd RPM is not installed
  func_wrapper rpm_not_installed httpd

  # CIS 3.12 Check dovecot RPM is not installed
  func_wrapper rpm_not_installed dovecot

  # CIS 3.13 Check samba RPM is not installed
  func_wrapper rpm_not_installed samba

  # CIS 3.14 Check squid RPM is not installed
  func_wrapper rpm_not_installed squid

  # CIS 3.15 Check net-snmp RPM is not installed
  func_wrapper rpm_not_installed net-snmp

  # CIS 3.16 MTA in local-only mode
  # Disable for now as function requires netstat and netstat is not part of the build
  #func_wrapper mta_local_only

  # CIS 4.1.1 IP Forwarding should be disabled
  func_wrapper chk_sysctl net.ipv4.ip_forward 0

  # CIS 4.1.2 Send Packet Redirects should be disabled
  func_wrapper chk_sysctl net.ipv4.conf.all.send_redirects 0
  func_wrapper chk_sysctl net.ipv4.conf.default.send_redirects 0

  # CIS 4.2.1 Source Routed Packet Acceptance should be disabled
  func_wrapper chk_sysctl net.ipv4.conf.all.accept_source_route 0
  func_wrapper chk_sysctl net.ipv4.conf.default.accept_source_route 0

  # CIS 4.2.2 ICMP Redirect Acceptance should be disabled
  func_wrapper chk_sysctl net.ipv4.conf.all.accept_redirects 0
  func_wrapper chk_sysctl net.ipv4.conf.default.accept_redirects 0

  # CIS 4.2.3 ICMP Redirect Acceptance should be disabled
  func_wrapper chk_sysctl net.ipv4.conf.all.secure_redirects 0
  func_wrapper chk_sysctl net.ipv4.conf.all.secure_redirects 0
  func_wrapper chk_sysctl net.ipv4.conf.default.secure_redirects 0

  # CIS 4.2.4 Log Suspicious Packets
  func_wrapper chk_sysctl net.ipv4.conf.all.log_martians 1
  func_wrapper chk_sysctl net.ipv4.conf.default.log_martians 1

  # CIS 4.2.5 Ignore Broadcast Requests should be enabled
  func_wrapper chk_sysctl net.ipv4.icmp_echo_ignore_broadcasts 1

  # CIS 4.2.6 Bad Error Message Protection should be enabled
  func_wrapper chk_sysctl net.ipv4.icmp_ignore_bogus_error_responses 1

  # CIS 4.2.7 RFC-recommended Source Route Validation should be enabled
  func_wrapper chk_sysctl net.ipv4.conf.all.rp_filter 1
  func_wrapper chk_sysctl net.ipv4.conf.default.rp_filter 1

  # CIS 4.2.8 TCP SYN Cookies should be enabled
  func_wrapper chk_sysctl net.ipv4.tcp_syncookies 1

  # TODO CIS 4.3.1 Check Wireless Interfaces are deactivated

  # CIS 4.4.1.1 If IPv6 enabled IPv6 Router Advertisements should be disabled
  func_wrapper ip6_router_advertisements_dis

  # CIS 4.4.1.2 If IPv6 enabled IPv6 Redirect Acceptance should be disabled
  func_wrapper ip6_redirect_accept_dis

  # CIS 4.4.2 IPv6 disabled
  func_wrapper chk_sysctl net.ipv6.conf.all.disable_ipv6 1

  # CIS 4.5.1 Check that TCP Wrappers are installed
  func_wrapper rpm_installed tcp_wrappers
  
  # CIS 4.5.2 Check that /etc/hosts.allow exists
  func_wrapper chk_file_exists ${HOSTS_ALLOW}
  
  # CIS 4.5.3 Verify permissions on /etc/hosts.allow
  func_wrapper check_root_owns ${HOSTS_ALLOW}
  func_wrapper check_file_perms ${HOSTS_ALLOW} 644 

  # CIS 4.5.4 Check that /etc/hosts.deny exists
  func_wrapper chk_file_exists ${HOSTS_DENY}
  func_wrapper chk_hosts_deny_content
  func_wrapper check_root_owns ${HOSTS_DENY}
  func_wrapper check_file_perms ${HOSTS_DENY} 644 

  # CIS 4.6.1 Check that CIS.conf file should disable uncommon network protocol dccp 
  func_wrapper chk_cis_cnf dccp ${CIS_CNF}

  # CIS 4.6.2 Check that CIS.conf file should disable uncommon network protocol sctp 
  func_wrapper chk_cis_cnf sctp ${CIS_CNF}

  # CIS 4.6.3 Check that CIS.conf file should disable uncommon network protocol rds 
  func_wrapper chk_cis_cnf rds ${CIS_CNF}

  # CIS 4.6.4 Check that CIS.conf file should disable uncommon network protocol tipc 
  func_wrapper chk_cis_cnf tipc ${CIS_CNF}
  
  # CIS 4.7 Firewalld should be enabled
  func_wrapper check_svc_enabled firewalld  

  # CIS 5.1.1 Check that rsyslog is installed
  func_wrapper rpm_installed rsyslog
  
  # CIS 5.1.2 rsyslog should be enabled
  func_wrapper check_svc_enabled rsyslog

  # CIS 5.1.3 Configure rsyslog.conf
  # This is too environment specific to audit for here 

  # CIS 5.1.4 Check perms on rsyslog.conf
  func_wrapper chk_file_exists ${RSYSLOG_CNF}
  func_wrapper check_root_owns ${RSYSLOG_CNF}
  func_wrapper check_file_perms ${RSYSLOG_CNF} 600 
  
  # CIS 5.1.5 rsyslog.conf sending logs to a remote host
  func_wrapper chk_rsyslog_content 

  # CIS 5.1.6 This benchmark is only applicable to rsyslog loghosts

  # CIS 5.2.1.1 Audit Log Storage Size should be configured
  func_wrapper audit_log_storage_size

  # CIS 5.2.1.2 Disable System on Audit Log Full
  func_wrapper dis_on_audit_log_full

  # CIS 5.2.1.3 Disable System on Audit Log Full
  func_wrapper keep_all_audit_info

  # CIS 5.2.2 auditd should be enabled
  func_wrapper check_svc_enabled auditd

  # CIS 5.2.3
  func_wrapper audit_procs_prior_2_auditd

  # CIS 5.2.4 Record events that modify date & time info
  func_wrapper audit_date_time

  # CIS 5.2.5 Record events that modify user & group info
  func_wrapper audit_user_group

  # CIS 5.2.6 Record events that modify the system's network env
  func_wrapper audit_network_env

  # CIS 5.2.7 Record events that modify the system's Mandatory Access Controls
  func_wrapper audit_sys_mac

  # CIS 5.2.8 Verify Collection Login and Logout events is configured
  func_wrapper audit_logins_logouts

  # CIS 5.2.9 Verify Collection of Session Initiation info is configured
  func_wrapper audit_session_init

  # CIS 5.2.10 Verify Collection of Discretionary Access Control permission modification events
  func_wrapper audit_dac_perm_mod_events

  # CIS 5.2.11 Verify collection of unsuccessful unauthorized access attempts to files
  func_wrapper unsuc_unauth_acc_attempts

  # CIS 5.2.12 Verify collection of privileged commands
  func_wrapper coll_priv_cmds

  # CIS 5.2.13 Verify collection of privileged commands
  func_wrapper coll_suc_fs_mnts

  # CIS 5.2.14 Verify collection of privileged commands
  func_wrapper coll_file_del_events

  # CIS 5.2.15 Verify collection of privileged commands
  func_wrapper coll_chg2_sysadm_scope

  # CIS 5.2.16 Verify collection of privileged commands
  func_wrapper coll_sysadm_actions 

  # CIS 5.2.17 Verify collection of Kernel Module Loading and Unloading
  func_wrapper kmod_lod_unlod

  # CIS 5.2.18 Verify collection of Kernel Module Loading and Unloading
  func_wrapper audit_cfg_immut

  # CIS 5.3 Log rotate should be configured
  func_wrapper logrotate_cfg

  # CIS 6.1.1 cron and anacron config
  func_wrapper rpm_installed cronie-anacron

  # CIS 6.1.2 enable crond daemon
  func_wrapper check_svc_enabled crond

  # CIS 6.1.3-6.1.8 user/group owner and perms on 
  # /etc/anacrontab /etc/crontab /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d

  for file in ${ANACRONTAB} ${CRONTAB} ${CRON_HOURLY} ${CRON_DAILY} ${CRON_WEEKLY} ${CRON_MONTHLY} ${CRON_DIR} ; do
    func_wrapper check_root_owns "${file}"
    func_wrapper check_file_perms "${file}" 600 
  done

  # CIS 6.1.10 at daemon config
  func_wrapper atd_cfg

  # CIS 6.1.11 restrict at/cron to authorized users
  func_wrapper at_cron_auth_users

  # CIS 6.2.1 SSH protocol should be 2
  func_wrapper chk_param "${SSHD_CFG}" Protocol 2

  # CIS 6.2.2 LogLevel to INFO
  func_wrapper chk_param "${SSHD_CFG}" LogLevel INFO
  
  # CIS 6.2.3 Permissions on sshd_config
  func_wrapper check_root_owns "${SSHD_CFG}"
  func_wrapper check_file_perms "${SSHD_CFG}" 600 

  # CIS 6.2.4 SSH X11Forwarding 
  func_wrapper chk_param "${SSHD_CFG}" X11Forwarding no
  
  # CIS 6.2.5 SSH MaxAuthTries 
  func_wrapper ssh_maxauthtries 4
  
  # CIS 6.2.6 SSH X11Forwarding 
  func_wrapper chk_param "${SSHD_CFG}" IgnoreRhosts yes
  
  # CIS 6.2.7 SSH HostbasedAuthentication
  func_wrapper chk_param "${SSHD_CFG}" HostbasedAuthentication no
  
  # CIS 6.2.8 SSH PermitRootLogin
  func_wrapper chk_param "${SSHD_CFG}" PermitRootLogin no
  
  # CIS 6.2.9 SSH PermitEmptyPasswords
  func_wrapper chk_param "${SSHD_CFG}" PermitEmptyPasswords no
  
  # CIS 6.2.10 SSH PermitUserEnvironment
  func_wrapper chk_param "${SSHD_CFG}" PermitUserEnvironment no
  
  # CIS 6.2.11 SSH Ciphers
  func_wrapper chk_param "${SSHD_CFG}" Ciphers aes128-ctr,aes192-ctr,aes256-ctr
  
  # CIS 6.2.12 SSH Idle Timeout Interval for User Login
  func_wrapper chk_param "${SSHD_CFG}" ClientAliveInterval 300
  func_wrapper chk_param "${SSHD_CFG}" ClientAliveCountMax 0
  
  # CIS 6.2.13 Limit access to SSH
  func_wrapper ssh_access
  
  # CIS 6.2.14 SSH banner
  func_wrapper chk_param "${SSHD_CFG}" Banner /etc/issue.net

  # CIS 6.3.1 SHA-512 password hashing algorithm
  func_wrapper pass_hash_algo sha512

  # CIS 6.3.2 password creation requirement parameters using pam_pwquality
  func_wrapper pass_req_params 

  # CIS 6.3.3 Set lockout for failed password attempts
  func_wrapper failed_pass_lock

  # CIS 6.3.4 Limit password reuse
  func_wrapper lim_passwd_reuse 

  # CIS 6.4 Restrict root login to system console
  # This is too env specific to put a check in for

  # CIS 6.5 Restrict access to su
  func_wrapper su_access

  # CIS 7.1.1 Password expiration days
  func_wrapper chk_param "${LOGIN_DEFS}" PASS_MAX_DAYS 90

  # CIS 7.1.2 Password change minimum number of days
  func_wrapper chk_param "${LOGIN_DEFS}" PASS_MIN_DAYS 7

  # CIS 7.1.3 Password expiring warning days
  func_wrapper chk_param "${LOGIN_DEFS}" PASS_WARN_AGE 7

  # CIS 7.2 Disable System Accounts
  func_wrapper dis_sys_accs

  # CIS 7.3 Default group for root account
  func_wrapper root_def_grp

  # CIS 7.4 Default group for root account
  func_wrapper def_umask_for_users 

  # CIS 7.5 Inactive User accounts should be locked
  func_wrapper inactive_usr_acs_locked
  
  # CIS 8.1 user/group owner and perms on 
  # /etc/motd /etc/issue /etc/issue.net

  for file in ${MOTD} ${ISSUE} ${ISSUE_NET} ; do
    func_wrapper check_root_owns "${file}"
    func_wrapper check_file_perms "${file}" 644 
  done

  # CIS 8.2 OS Information should not be in Login Warning Banners
  func_wrapper warning_banners
  
  # CIS 8.3 Set GNOME Warning Banner
  # On a host aiming to meet CIS requirements GNOME is unlikely to be installed 
  # Thus the function says if the file exists then it should have these lines in it
  func_wrapper gnome_banner
  
  # CIS 9.1.2 Verify perms on /etc/passwd 
  func_wrapper check_file_perms "${PASSWD}" 644 
  
  # CIS 9.1.3 Verify perms on /etc/shadow 
  func_wrapper check_file_perms "${SHADOW}" 0

  # CIS 9.1.4 Verify perms on /etc/gshadow 
  func_wrapper check_file_perms "${GSHADOW}" 0 

  # CIS 9.1.5 Verify perms on /etc/group 
  func_wrapper check_file_perms "${GROUP}" 644 

  # CIS 9.1.6-9 user/group owner and perms on /etc/passwd /etc/shadow /etc/gshadow /etc/group
  for file in ${PASSWD} ${SHADOW} ${GSHADOW} ${GROUP} ; do
    func_wrapper check_root_owns "${file}"
  done

  # CIS 9.1.10 Shouldn't have any world writable files
  func_wrapper world_w_dirs

  # CIS 9.1.11 Shouldn't have any unowned files & dirs
  func_wrapper unowned_files
    
  # CIS 9.1.12 Shouldn't have any ungrouped files & dirs
  func_wrapper ungrouped_files

  # CIS 9.1.13 Check for suid executables
  func_wrapper suid_exes

  # CIS 9.1.14 Check for sgid executables
  func_wrapper sgid_exes

  # CIS 9.2.1 Ensure password fields are not empty
  func_wrapper passwd_field_chk

  # CIS 9.2.2 Verify no legacy "+" entries exist in /etc/passwd
  func_wrapper nis_in_file ${PASSWD}

  # CIS 9.2.3 Verify no legacy "+" entries exist in /etc/shadow
  func_wrapper nis_in_file ${SHADOW}

  # CIS 9.2.4 Verify no legacy "+" entries exist in /etc/group
  func_wrapper nis_in_file ${GROUP}

  # CIS 9.2.5 Verify no UID 0 accounts exist other than root
  func_wrapper no_uid0_other_root
  
  # CIS 9.2.6 Ensure root PATH integrity
  func_wrapper root_path

  # CIS 9.2.7 Home dir perms
  func_wrapper home_dir_perms

  # CIS 9.2.8 User dot file permissions
  func_wrapper dot_file_perms

  # CIS 9.2.9 User .netrc permissions
  func_wrapper dot_netrc_perms

  # CIS 9.2.10 User .rhosts files
  func_wrapper dot_rhosts_files

  # CIS 9.2.11 User .rhosts files
  func_wrapper chk_groups_passwd

  # CIS 9.2.12 User .rhosts files
  func_wrapper chk_home_dirs_exist

  # CIS 9.2.13 Check home directory ownership
  func_wrapper chk_home_dirs_owns

  # CIS 9.2.14 Check for Duplicate UIDs in /etc/passwd
  func_wrapper duplicate_uids

  # CIS 9.2.15 Check for Duplicate GIDs in /etc/group
  func_wrapper duplicate_gids

  # CIS 9.2.16 Check that reserved uids are assigned 
  func_wrapper chk_uids_4_res

  # CIS 9.2.17 Check for Duplicate usernames in /etc/passwd
  func_wrapper duplicate_usernames

  # CIS 9.2.18 Check for Duplicate groupnames in /etc/group
  func_wrapper duplicate_groupnames

  # CIS 9.2.19 Check for presence of user .netrc files
  func_wrapper user_dot_netrc 

  # CIS 9.2.20 Check for presence of user .forward files
  func_wrapper user_dot_forward 
echo -e "\e[00;33m### SCAN COMPLETE ####\e[00m" |tee -a $report 2>/dev/null
echo -e "\e[00;33mGo fix them, will you?" |tee -a $report 2>/dev/null
}

main
