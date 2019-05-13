#!/usr/bin/env bash
# Qriket Auto Claim Spin Balance
# By Versailles
# Sec7or Team ~ Love You Canssss <3
# Ojo Lali gawe refferal ku coeg : LZY69S Suwun :)

GR='\033[92m'
RD='\033[91m'
NT='\033[0m'

login(){
	curl -s "https://goldcloudbluesky.com/app/login" \
	-H "Content-Type: application/json" \
	-H "device-type: Android" \
	-H "user-agent: okhttp/3.8.0" \
	-d '{"email":"'$1'","password":"'$2'"}'
}

campaigns(){
	curl -s "https://goldcloudbluesky.com/campaigns" \
	-H "accept: application/json" \
	-H "authorization: Bearer $1" \
	-H "device-type: Android" \
	-H "device-hardware: " \
	-H "device-version: null" \
	-H "user-agent: okhttp/3.8.0"
}

claim(){
	curl -s "https://goldcloudbluesky.com/campaigns/claim" \
	-H "Content-Type: application/json" \
	-H "accept: application/json" \
	-H "authorization: Bearer $1" \
	-H "device-type: Android" \
	-H "device-hardware: " \
	-H "device-version: null" \
	-H "user-agent: okhttp/3.8.0" \
	-d '{"campaign":"'$2'","network":"'$3'","referralGoal":"false"}'
}

qriket(){
	melbu=$(login $1 $2)
	toket=$(echo $melbu | grep -oP '"accessToken":"\K[^"]+')

	if [[ -z $toket ]]; then 
		echo "[!] Login Failed"
		exit
	else
		f=$(echo $melbu | jq -r '.account.user.firstName')
		l=$(echo $melbu | jq -r '.account.user.lastName')	
		echo -e "[+] Logged-In As ${GR}$f $l${NT}"
		echo
		while :; do
			c=$(campaigns $toket)
			for i in $(echo $c | jq '.campaigns.networks | keys | .[]'); do
				v=$(echo $c | jq -r ".campaigns.networks[$i]")
				camp=$(echo $v | jq -r '.campaign')
				netw=$(echo $v | jq -r '.network')			
				o=$(claim $toket $camp $netw)
				r=$(echo $o | grep -ic "title")
				if [[ $r =~ "0" ]]; then
					re=$(echo $o | jq -r '.reward.amount')
					bal=$(echo $o | jq -r '.balance.spins')
					echo -e "[+] ${GR}Claimed $re Spins | Balance Spins : $bal${NT}"
					sleep 5
				else
					er=$(echo $o | jq -r '.errors[0]')				
					echo -e "[-] ${RD}$er${NT}"
					sleep 40
					break
				fi				
			done
		done
	fi
}

cat <<EOF

+------------------------------------------------+
|		Qriket Auto Claim Spin Balance
|		By : Viloid
|		Sec7or Team ~ Love You Cans
+------------------------------------------------+

EOF
read -p "[?] Email : " email
read -p "[?] Password : " pass
echo
qriket $email $pass
