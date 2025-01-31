test_if_variable_is_defined () {
  # $1 variable to check
  # $2 indentation message
  # $3 test detail message
  echo "$2+++ $3"
  if [[ $1 == "null" || $1 == '""' ]]; then
    exit 255
  fi
}
#
test_if_json_variable_is_defined () {
  # $1 key variable to check
  # $2 json file
  # $3 indentation message
  echo "$3+++ testing if $1 is not empty"
  if [[ $(jq -c -r $1 $2) == "null" || $(jq -c $1 $2) == '""' ]]; then
    exit 255
  fi
}
#
function test_if_variable_is_valid_ip () {
  # $1 is variable to check
  # $2 indentation message
  echo "$2+++ testing if $1 is a valid IP"
  local  ip=$1
  local  stat=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
        && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  if [[ $stat -ne 0 ]] ; then echo "$2$1 does not seem to be an IP" ; exit 255 ; fi
}
#
function test_if_variable_is_valid_cidr () {
  # $1 is variable to check
  # $2 indentation message
  echo "$2+++ testing if $1 is a valid CIDR"
  local  ip=$(echo $1 | cut -d"/" -f1)
  local  prefix=$(echo $1 | cut -d"/" -f2)
  local  stat=1
  local  test_prefix=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
        && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  if [[ $prefix -ge 2 && $prefix -le 32 ]]; then test_prefix=0 ; fi
  if [[ $stat -ne 0 || $test_prefix -ne 0 ]] ; then echo "$2$1 does not seem to be a valid CIDR" ; exit 255 ; fi
}
#
test_if_ref_from_list_exists_in_another_list () {
  # $1 list + ref to check
  # $2 list + ref to check against
  # $3 json file
  # $4 message to display
  # $5 message to display if match
  # $6 error to display
  echo $4
  for ref in $(jq -c -r $1 $3)
  do
    check_status=0
    for item_name in $(jq -c -r $2 $3)
    do
      if [[ $ref = $item_name ]] ; then check_status=1 ; echo "$5found: $ref, OK"; fi
    done
  done
  if [[ $check_status -eq 0 ]] ; then echo "$6$ref" ; exit 255 ; fi
}