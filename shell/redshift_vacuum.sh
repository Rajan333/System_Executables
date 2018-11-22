#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

DATE=`date`
ENDPOINT="REDSHIFT_ENDPOINT"
PORT="5439"
USER="REDSHIFT_USER"
DB="inno"


## Connect to PSQL ##
export PGPASSWORD="REDSHIFT_PASSWORD"

main(){
	psql -h "$ENDPOINT" -p "$PORT" -U "$USER" -d "$DB" << EOF
	VACUUM FULL allergy;
	VACUUM FULL appointment;
	VACUUM FULL attribution;
	VACUUM FULL claim_header;
	VACUUM FULL claim_line;
	VACUUM FULL diagnosis;
	VACUUM FULL empi;
	VACUUM FULL encounter;
	VACUUM FULL family_history;
	VACUUM FULL immunization;
	VACUUM FULL insurance;
	VACUUM FULL lab_result;
	VACUUM FULL medical_equipment;
	VACUUM FULL member;
	VACUUM FULL member_add;
	VACUUM FULL member_altid;
	VACUUM FULL member_contact;
	VACUUM FULL member_email;
	VACUUM FULL member_lang;
	VACUUM FULL pharmacy_claim ;
	VACUUM FULL pharmacy_claim;
	VACUUM FULL provider_org_hierarchy;
	VACUUM FULL procedure;
	VACUUM FULL problem;
	VACUUM FULL prescription;
	VACUUM FULL social_history;
	VACUUM FULL pd_activity;
	VACUUM FULL pd_attribution;
	VACUUM FULL pd_org;

	ANALYZE allergy;
	ANALYZE appointment;
	ANALYZE attribution;
	ANALYZE claim_header;
	ANALYZE claim_line;
	ANALYZE diagnosis;
	ANALYZE empi;
	ANALYZE encounter;
	ANALYZE family_history;
	ANALYZE immunization;
	ANALYZE insurance;
	ANALYZE lab_result;
	ANALYZE medical_equipment;
	ANALYZE member;
	ANALYZE member_add;
	ANALYZE member_altid;
	ANALYZE member_contact;
	ANALYZE member_email;
	ANALYZE member_lang;
	ANALYZE pharmacy_claim ;
	ANALYZE pharmacy_claim;
	ANALYZE provider_org_hierarchy;
	ANALYZE procedure;
	ANALYZE problem;
	ANALYZE prescription;
	ANALYZE social_history;
	ANALYZE pd_activity;
	ANALYZE pd_attribution;
	ANALYZE pd_org;
EOF
}
STATUS="$?"

if [ "$STATUS" == "0" ];then
	echo "Redshift vaccum and analyze process completed.successfully on $DATE" | mailx -v -s "Orlando: REDSHIFT VACUUM" -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login -S smtp=smtp://smtp.gmail.com:587 -S from="infra@innovaccer.com(Orlando-Redshift)" -S smtp-auth-user=infra@innovaccer.com -S smtp-auth-password="mailpasswd" -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb rajan.middha@innovaccer.com

else
	 echo "Redshift vaccum and analyze process FAILED on $DATE" | mailx -v -s "Orlando: REDSHIFT VACUUM" -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login -S smtp=smtp://smtp.gmail.com:587 -S from="infra@innovaccer.com(Orlando-Redshift)" -S smtp-auth-user=infra@innovaccer.com -S smtp-auth-password="mailpasswd" -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb rajan.middha@innovaccer.com
fi


